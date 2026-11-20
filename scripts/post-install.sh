#!/usr/bin/env bash
# NIXMANIA post-install: swap the plain sops age key for the TPM identity.
# usage: scripts/post-install.sh [swap|finalize|status]
#   swap      restore the TPM identity from its encrypted backup (run after first boot)
#   finalize  after a reboot, confirm the TPM path works, then delete the plain key
#   status    report key type, TPM, Secure Boot and secrets state
set -Eeuo pipefail

REPO_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"
readonly REPO_DIR

readonly SECRETS_FILE="${SECRETS_FILE:-${REPO_DIR}/secrets/secrets.yaml}"
readonly KEY_FILE="${KEY_FILE:-/persistent/var/lib/sops-nix/key.txt}"
readonly PLAIN_BACKUP="${KEY_FILE}.plain"
readonly TPM_DEVICE="${TPM_DEVICE:-/dev/tpmrm0}"
readonly SECRETS_LINK="${SECRETS_LINK:-/run/secrets}"
readonly TMP_DIR="${TMP_DIR:-/run}"
readonly TPM_BACKUP_NAMES=(tpm-identity.txt.age tpm-identity.age)
readonly TPM_IDENTITY_BACKUP="${TPM_IDENTITY_BACKUP:-}"

INVOKER="${SUDO_USER:-bugs}"
INVOKER_HOME="$(getent passwd "$INVOKER" | cut -d: -f6 || true)"
INVOKER_HOME="${INVOKER_HOME:-/home/${INVOKER}}"
readonly INVOKER INVOKER_HOME

export NIX_CONFIG="extra-experimental-features = nix-command flakes"

readonly B="\033[1m"
readonly R="\033[1;31m"
readonly Y="\033[1;33m"
readonly G="\033[1;32m"
readonly C="\033[1;36m"
readonly M="\033[1;35m"
readonly D="\033[2m"
readonly RST="\033[0m"

TMP_IDENTITY=""

print_status() {
	local status="$1"
	local message="$2"
	local color icon

	case "$status" in
	"OK") color="$G" icon="*" ;;
	"WARNING") color="$Y" icon="!" ;;
	"FAILED") color="$R" icon="X" ;;
	"INFO") color="$C" icon="i" ;;
	"PROMPT") color="$M" icon="?" ;;
	*) color="$B" icon="$status" ;;
	esac

	echo -e "${color}${icon}${RST} ${D}|${RST} ${B}${message}${RST}"
}

die() {
	print_status "FAILED" "$1"
	exit 1
}

confirm_prompt() {
	local prompt="$1"
	local response

	while true; do
		echo -ne "${M}>${RST} ${D}| ${prompt} [y/n]:${RST} "
		read -r response
		case "$response" in
		y) return 0 ;;
		n) return 1 ;;
		*) print_status "FAILED" "Please type 'y' or 'n'" ;;
		esac
	done
}

usage() {
	echo "usage: ${0##*/} [swap|finalize|status]"
	echo "  swap      restore the TPM identity from its encrypted backup"
	echo "  finalize  after a reboot, check the TPM path works, delete the plain key"
	echo "  status    report key type, TPM, Secure Boot and secrets state"
}

on_error() {
	print_status "FAILED" "Aborted at line $1: $2"
	exit 1
}

cleanup() {
	if [[ -n "$TMP_IDENTITY" ]]; then
		rm -f "$TMP_IDENTITY"
	fi
}

require_root() {
	if [[ $EUID -ne 0 ]]; then
		exec sudo --preserve-env=TPM_IDENTITY_BACKUP "$0" "$@"
	fi
}

ensure_tool() {
	local cmd="$1" attr="$2" out path

	if command -v "$cmd" >/dev/null 2>&1; then
		return 0
	fi

	print_status "INFO" "Fetching $cmd..."
	out="$(nix build --no-link --print-out-paths "nixpkgs#${attr}")" ||
		die "Could not fetch $attr"

	while IFS= read -r path; do
		if [[ -d "${path}/bin" ]]; then
			PATH="${path}/bin:${PATH}"
		fi
	done <<<"$out"

	command -v "$cmd" >/dev/null 2>&1 || die "$cmd still not found after fetching $attr"
	print_status "OK" "$cmd added to PATH"
}

ensure_crypto_tools() {
	ensure_tool age age
	ensure_tool sops sops
	ensure_tool age-plugin-tpm age-plugin-tpm
}

# Classify the installed key file: tpm | plain | unknown | missing
key_type() {
	if [[ ! -f "$KEY_FILE" ]]; then
		echo "missing"
	elif grep -q '^AGE-PLUGIN-TPM-' "$KEY_FILE"; then
		echo "tpm"
	elif grep -q '^AGE-SECRET-KEY-' "$KEY_FILE"; then
		echo "plain"
	else
		echo "unknown"
	fi
}

# Can the given age identity file decrypt the whole secrets file?
can_decrypt() {
	SOPS_AGE_KEY_FILE="$1" sops -d "$SECRETS_FILE" >/dev/null 2>&1
}

find_tpm_backup() {
	local dir name
	local dirs=("${INVOKER_HOME}/Downloads" "$INVOKER_HOME" "/run/media/${INVOKER}"/* "$REPO_DIR" "$PWD")

	if [[ -n "$TPM_IDENTITY_BACKUP" && -f "$TPM_IDENTITY_BACKUP" ]]; then
		echo "$TPM_IDENTITY_BACKUP"
		return 0
	fi
	for dir in "${dirs[@]}"; do
		for name in "${TPM_BACKUP_NAMES[@]}"; do
			if [[ -f "${dir}/${name}" ]]; then
				echo "${dir}/${name}"
				return 0
			fi
		done
	done
	return 1
}

print_rekey_steps() {
	echo
	print_status "INFO" "To create a NEW TPM identity (TPM cleared or new hardware):"
	echo "    age-plugin-tpm --generate -o /root/tpm-identity.txt"
	echo "    age-plugin-tpm -y --tpm-recipient /root/tpm-identity.txt   # new recipient for .sops.yaml (&tpm)"
	echo "    # edit .sops.yaml, then re-encrypt with the plain key:"
	echo "    sudo env SOPS_AGE_KEY_FILE=${KEY_FILE} PATH=\"\$PATH\" sops updatekeys secrets/secrets.yaml"
	echo "    # save an age-encrypted backup of the new identity, then run this script again"
	echo
}

check_secure_boot() {
	local status

	if [[ ! -d /sys/firmware/efi ]]; then
		print_status "WARNING" "Not booted in UEFI mode, skipping Secure Boot check"
		return 0
	fi
	ensure_tool sbctl sbctl
	status="$(sbctl status 2>/dev/null || true)"

	if grep -qE '^Secure Boot:.*Enabled' <<<"$status"; then
		print_status "OK" "Secure Boot is enabled"
	elif grep -qE '^Setup Mode:.*Enabled' <<<"$status"; then
		print_status "WARNING" "Firmware is in Setup Mode: your keys are not enrolled"
		if confirm_prompt "Enroll your keys now (sbctl enroll-keys --microsoft)?"; then
			sbctl enroll-keys --microsoft
			print_status "OK" "Keys enrolled. Enable Secure Boot in the BIOS, then reboot"
		fi
	else
		print_status "WARNING" "Secure Boot is disabled. Enable it in the BIOS when you are ready"
	fi
}

cmd_swap() {
	local src

	ensure_crypto_tools

	case "$(key_type)" in
	tpm)
		can_decrypt "$KEY_FILE" || die "Key file is a TPM identity but cannot decrypt secrets.yaml"
		print_status "OK" "Key file is already a TPM identity and decrypts secrets.yaml"
		return 0
		;;
	plain) ;;
	*) die "Unexpected state of ${KEY_FILE}: $(key_type)" ;;
	esac

	[[ -c "$TPM_DEVICE" ]] || die "No TPM device at ${TPM_DEVICE}"
	can_decrypt "$KEY_FILE" || die "The current plain key cannot decrypt secrets.yaml. Nothing was changed"
	print_status "OK" "Current plain key decrypts secrets.yaml"

	if ! src="$(find_tpm_backup)"; then
		print_status "FAILED" "No encrypted TPM identity (${TPM_BACKUP_NAMES[*]}) found"
		print_status "INFO" "Plug in the backup, or set TPM_IDENTITY_BACKUP=/path/to/file"
		print_rekey_steps
		exit 1
	fi

	print_status "INFO" "Found encrypted TPM identity: $src (enter its passphrase)"
	TMP_IDENTITY="$(mktemp -p "$TMP_DIR")"
	(umask 077 && age -d "$src" >"$TMP_IDENTITY") || die "Could not decrypt $src"
	grep -q '^AGE-PLUGIN-TPM-' "$TMP_IDENTITY" || die "No AGE-PLUGIN-TPM line in $src"

	if ! can_decrypt "$TMP_IDENTITY"; then
		print_status "FAILED" "The TPM identity does not decrypt secrets.yaml on this machine"
		print_status "INFO" "The TPM was probably cleared, or this is different hardware"
		print_rekey_steps
		exit 1
	fi
	print_status "OK" "TPM identity decrypts secrets.yaml"

	mv "$KEY_FILE" "$PLAIN_BACKUP"
	install -m 0400 -o root -g root "$TMP_IDENTITY" "$KEY_FILE"
	if ! can_decrypt "$KEY_FILE"; then
		mv -f "$PLAIN_BACKUP" "$KEY_FILE"
		die "Installed identity failed its check; the plain key was restored"
	fi

	print_status "OK" "TPM identity installed at ${KEY_FILE}"
	print_status "INFO" "Plain key kept as ${PLAIN_BACKUP} until you finalize"
	check_secure_boot
	echo
	print_status "WARNING" "Reboot now, then run: ${0##*/} finalize"
}

cmd_finalize() {
	local gen

	ensure_crypto_tools

	[[ "$(key_type)" == "tpm" ]] || die "Key file is not a TPM identity. Run '${0##*/} swap' first"
	can_decrypt "$KEY_FILE" || die "TPM identity cannot decrypt secrets.yaml"

	gen="$(readlink -f "$SECRETS_LINK" 2>/dev/null || true)"
	[[ -n "$gen" && -d "$gen" ]] || die "${SECRETS_LINK} is missing, sops-nix did not run"
	[[ -n "$(ls -A "$gen")" ]] || die "${SECRETS_LINK} is empty, sops-nix could not decrypt"
	if [[ "$(stat -c %Y "$gen")" -le "$(stat -c %Y "$KEY_FILE")" ]]; then
		die "Secrets were decrypted before the swap. Reboot (or rebuild), then finalize again"
	fi
	print_status "OK" "sops-nix decrypted ${SECRETS_LINK} with the TPM identity"

	if [[ -f "$PLAIN_BACKUP" ]]; then
		if confirm_prompt "Delete the plain key ${PLAIN_BACKUP}?"; then
			rm -f "$PLAIN_BACKUP"
			print_status "OK" "Plain key removed (old ZFS snapshots may still hold a copy)"
		else
			print_status "WARNING" "Plain key kept"
		fi
	else
		print_status "INFO" "No plain key backup present"
	fi
	check_secure_boot
}

cmd_status() {
	local gen n=0

	print_status "INFO" "Key file: $(key_type) (${KEY_FILE})"
	if [[ -c "$TPM_DEVICE" ]]; then
		print_status "OK" "TPM device present"
	else
		print_status "WARNING" "No TPM device at ${TPM_DEVICE}"
	fi
	if [[ -f "$PLAIN_BACKUP" ]]; then
		print_status "WARNING" "Plain key backup still present: ${PLAIN_BACKUP}"
	fi
	gen="$(readlink -f "$SECRETS_LINK" 2>/dev/null || true)"
	if [[ -n "$gen" && -d "$gen" ]]; then
		n="$(find "$gen" -mindepth 1 -maxdepth 1 | wc -l)"
	fi
	print_status "INFO" "Decrypted secrets present: ${n}"
	check_secure_boot
}

main() {
	trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR
	trap cleanup EXIT

	local cmd="${1:-swap}"

	case "$cmd" in
	swap | finalize | status) ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		usage
		exit 1
		;;
	esac

	require_root "$@"

	"cmd_${cmd}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	main "$@"
fi
