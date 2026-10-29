#!/usr/bin/env bash
# NIXMANIA installer: ZFS (native encryption) + rollback root + preservation.
# usage: scripts/install.sh [host] [--wipe]
set -Eeuo pipefail

# globals
REPO_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"
readonly REPO_DIR
readonly TARGET_ROOT="/mnt"
readonly PERSIST="${TARGET_ROOT}/persistent"

readonly USERNAME="bugs"
readonly USER_UID=1000
readonly USER_GID=100
readonly USER_HOME="${PERSIST}/home/${USERNAME}"

readonly DISKO_REF="github:nix-community/disko/latest"
readonly ZROOT_KEY="/tmp/zroot.key"
readonly ZSTORAGE_KEY="/tmp/zstorage.key"
readonly ZSTORAGE_KEY_PERSISTED="${PERSIST}/zfs-keys/zstorage.key"
readonly ZSTORAGE_KEYLOCATION="file:///persistent/zfs-keys/zstorage.key"

readonly AGE_KEY_TARGET="${PERSIST}/var/lib/sops-nix/key.txt"
readonly AGE_BACKUP_NAMES=(key.txt.age key.age)
readonly AGE_SEARCH_DIRS=(/home/nixos/Downloads /home/nixos /root/Downloads /root "$REPO_DIR" "$PWD")
readonly AGE_KEY_FILE="${AGE_KEY_FILE:-}"
readonly PASSWD_DIR="${PERSIST}/passwd"

readonly ZRAM_SIZE="20G"
readonly ZFS_ARC_MAX_BYTES=2147483648
readonly PASSWORD_MIN_LENGTH=8
readonly PASSWORD_MAX_LENGTH=512
readonly REQUIRED_TOOLS=(git curl mkpasswd lsblk zramctl blkdiscard wipefs zpool zfs nix nixos-generate-config nixos-install)

export NIX_CONFIG="extra-experimental-features = nix-command flakes pipe-operators"

readonly B="\033[1m"
readonly R="\033[1;31m"
readonly Y="\033[1;33m"
readonly G="\033[1;32m"
readonly C="\033[1;36m"
readonly M="\033[1;35m"
readonly D="\033[2m"
readonly RST="\033[0m"

HOST=""
WIPE=false
FLAKE_REF=""
FLAKE_ATTR=""
MAIN_DISK=""
DATA_DISK=""
ZFS_PASS=""
USER_PASS=""
ROOT_PASS=""
HW_CHANGED=false

# ┏┓ ┏━┓┏┓╻┏┓╻┏━╸┏━┓┏━┓
# ┣┻┓┣━┫┃┗┫┃┗┫┣╸ ┣┳┛┗━┓
# ┗━┛╹ ╹╹ ╹╹ ╹┗━╸╹┗╸┗━┛
main_banner() {
	echo -ne "${B}${C}"
	cat <<'BANNER'
         ██╗                                        ██╗
██████╗  ╚═╝██╗   ██╗████████╗    ██████╗  ██████╗  ╚═╝  ██████╗
██╔═══██╗██╗╚═████╔═╝██╔═██╔═██╗██╔═══██║  ██╔═══██╗██╗██╔═══██║
██║   ██║██║  ████║  ██║ ██║ ██║██║   ██║  ██║   ██║██║██║   ██║
██║   ██║██║██╔═══██╗██║ ██║ ██║╚═████████╗██║   ██║██║╚═████████╗
╚═╝   ╚═╝╚═╝╚═╝   ╚═╝╚═╝ ╚═╝ ╚═╝  ╚═══════╝╚═╝   ╚═╝╚═╝  ╚═══════╝
BANNER
	echo -e "${RST}${D} declarative nixos deployment utility${RST}\n"
}

done_banner() {
	echo -ne "${B}${G}"
	cat <<'BANNER'
      ██╗
  ██████║  ████╗  ██████╗    ████╗
██╔═══██║██╔═══██╗██╔═══██╗████████╗
██║   ██║██║   ██║██║   ██║██╔═════╝
╚═██████║╚═████╔═╝██║   ██║╚═██████╗
  ╚═════╝  ╚═══╝  ╚═╝   ╚═╝  ╚═════╝
BANNER
	echo -e "${RST}"
}

stage() {
	clear 2>/dev/null || true
	main_banner
	echo -e "${D}Stage $1 - $2${RST}"
	echo
}

pause() {
	echo
	read -rp "$(echo -e "${D}Press Enter to continue...${RST}")"
}

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

input_prompt() {
	local prompt="$1"
	local var_name="$2"

	echo -ne "${M}>${RST} ${D}| ${prompt}${RST}"
	read -r "${var_name?}"
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
	echo "usage: ${0##*/} [host] [--wipe]"
	echo "  host     directory name under hosts/ (asked interactively if omitted)"
	echo "  --wipe   secure-erase / discard both disks before partitioning"
}

parse_args() {
	local arg
	for arg in "$@"; do
		case "$arg" in
		--wipe) WIPE=true ;;
		-h | --help)
			usage
			exit 0
			;;
		-*)
			print_status "FAILED" "Unknown option: $arg"
			usage
			exit 1
			;;
		*)
			if [[ -n "$HOST" ]]; then
				print_status "FAILED" "Only one host may be given"
				usage
				exit 1
			fi
			HOST="$arg"
			;;
		esac
	done
}

on_error() {
	print_status "FAILED" "Aborted at line $1: $2"
	exit 1
}

cleanup() {
	rm -f "$ZROOT_KEY" "$ZSTORAGE_KEY"
}

target_disks() {
	local d
	for d in "$MAIN_DISK" "$DATA_DISK"; do
		if [[ -n "$d" ]]; then
			readlink -f "$d"
		fi
	done
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ╺┓
# ┗━┓ ┃ ┣━┫┃╺┓┣╸     ┃
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸   ╺┻╸
check_root() {
	if [[ $EUID -ne 0 ]]; then
		die "Must be run as root"
	fi
	print_status "OK" "Running as root"
}

check_internet() {
	if ! curl -fsS --max-time 10 -o /dev/null https://cache.nixos.org/nix-cache-info; then
		die "No internet connection (cache.nixos.org unreachable)"
	fi
	print_status "OK" "Internet connection active"
}

check_tools() {
	local cmd
	for cmd in "${REQUIRED_TOOLS[@]}"; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			die "Required tool '$cmd' is missing"
		fi
		print_status "OK" "$cmd is available"
	done

	if ! command -v nvme >/dev/null 2>&1; then
		print_status "WARNING" "nvme-cli missing (will use nix shell)"
		nvme() { nix shell nixpkgs#nvme-cli --command nvme "$@"; }
	fi
	if ! command -v age >/dev/null 2>&1; then
		print_status "WARNING" "age missing (will use nix shell)"
		age() { nix shell nixpkgs#age --command age "$@"; }
	fi
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ┏━┓
# ┗━┓ ┃ ┣━┫┃╺┓┣╸    ┏━┛
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸   ┗━╸
prompt_host() {
	local hosts=() dir i choice

	for dir in "${REPO_DIR}"/hosts/*/; do
		if [[ -f "${dir}configuration.nix" && -f "${dir}disko.nix" ]]; then
			hosts+=("$(basename "$dir")")
		fi
	done

	if [[ ${#hosts[@]} -eq 0 ]]; then
		die "No valid host configurations found in ${REPO_DIR}/hosts/"
	fi

	if [[ -n "$HOST" ]]; then
		if [[ " ${hosts[*]} " != *" ${HOST} "* ]]; then
			die "Host '$HOST' not found in hosts/ (have: ${hosts[*]})"
		fi
	else
		print_status "PROMPT" "Available hosts:"
		for i in "${!hosts[@]}"; do
			echo -e "${B}$((i + 1))${RST} ${D}|${RST} ${hosts[i]}"
		done
		while true; do
			input_prompt "Pick host number: " choice
			if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#hosts[@]})); then
				HOST="${hosts[choice - 1]}"
				break
			fi
			print_status "FAILED" "Invalid selection"
		done
	fi

	FLAKE_REF="${REPO_DIR}#${HOST}"
	FLAKE_ATTR="${REPO_DIR}#nixosConfigurations.${HOST}"
	print_status "OK" "Using target host: ${B}${HOST}${RST}"
}

first_eval() {
	local sys d

	sys="$(nix eval --raw --impure --expr builtins.currentSystem)"

	print_status "INFO" "Evaluating flake, fetching inputs (first run is slow)..."
	nix eval --raw "${FLAKE_ATTR}.config.system.build.toplevel.drvPath" >/dev/null ||
		die "Flake evaluation failed for host ${HOST}"
	nix build --no-link "${REPO_DIR}#formatter.${sys}" ||
		die "Could not build the flake formatter"
	print_status "OK" "First flake evaluation complete without errors"

	MAIN_DISK="$(nix eval --raw "${FLAKE_ATTR}.config.storage.zfs.device")"
	DATA_DISK="$(nix eval --raw --apply 'x: if x == null then "" else x' "${FLAKE_ATTR}.config.storage.zfs.dataDevice")"

	if [[ -z "$MAIN_DISK" ]]; then
		die "Flake does not define a main disk (storage.zfs.device)"
	fi
	for d in "$MAIN_DISK" "$DATA_DISK"; do
		if [[ -n "$d" && ! -e "$d" ]]; then
			die "Disk path from the flake does not exist on this machine: $d"
		fi
	done
	if [[ -n "$DATA_DISK" && "$(readlink -f "$MAIN_DISK")" == "$(readlink -f "$DATA_DISK")" ]]; then
		die "Main disk and data disk resolve to the same device"
	fi

	print_status "OK" "Main disk: ${MAIN_DISK}"
	if [[ -n "$DATA_DISK" ]]; then
		print_status "OK" "Data disk: ${DATA_DISK}"
	else
		print_status "INFO" "No data disk configured (no zstorage pool)"
	fi
}

prompt_password() {
	local var_name="$1"
	local pass confirm

	while true; do
		echo -ne "${M}>${RST} ${D}| Enter password:${RST} "
		read -rs pass
		echo ""

		echo -ne "${M}>${RST} ${D}| Confirm password:${RST} "
		read -rs confirm
		echo ""

		if [[ "$pass" == "$confirm" && ${#pass} -ge $PASSWORD_MIN_LENGTH && ${#pass} -le $PASSWORD_MAX_LENGTH ]]; then
			printf -v "$var_name" '%s' "$pass"
			return 0
		fi
		print_status "FAILED" "Passwords must match and be ${PASSWORD_MIN_LENGTH}-${PASSWORD_MAX_LENGTH} characters"
	done
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ┏━┓
# ┗━┓ ┃ ┣━┫┃╺┓┣╸    ╺━┫
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸   ┗━┛
confirm_destroy() {
	local ans
	local -a disks

	mapfile -t disks < <(target_disks)

	print_status "INFO" "Target host: ${B}${HOST}${RST}"
	print_status "INFO" "Secure wipe first (--wipe): ${B}${WIPE}${RST}"
	print_status "WARNING" "EVERYTHING on these disks will be destroyed, with or without --wipe:"
	lsblk -d -o NAME,SIZE,MODEL,SERIAL,ROTA "${disks[@]}"
	echo
	input_prompt "Type the hostname (${HOST}) to continue: " ans
	if [[ "$ans" != "$HOST" ]]; then
		print_status "INFO" "Aborted."
		exit 1
	fi
}

iso_prep() {
	local zdev

	print_status "INFO" "Configuring ISO environment (zram swap, ZFS ARC cap)..."
	if [[ "$(swapon --show=NAME --noheadings)" != *zram* ]]; then
		modprobe zram
		zdev="$(zramctl --find --size "$ZRAM_SIZE" --algorithm zstd)"
		mkswap "$zdev" >/dev/null
		swapon --priority 100 "$zdev"
	fi
	modprobe zfs || die "Could not load the zfs kernel module on this ISO"
	if [[ -w /sys/module/zfs/parameters/zfs_arc_max ]]; then
		echo "$ZFS_ARC_MAX_BYTES" >/sys/module/zfs/parameters/zfs_arc_max
	fi
}

wipe_one() {
	local disk="$1"

	case "$disk" in
	/dev/nvme*)
		print_status "INFO" "NVMe user-data erase (--ses=1): $disk"
		if ! nvme format "$disk" --ses=1 --force; then
			print_status "WARNING" "nvme format failed, falling back to blkdiscard"
			blkdiscard -f "$disk"
		fi
		;;
	*)
		if [[ "$(lsblk -dno ROTA "$disk" | tr -d '[:space:]')" == "0" ]]; then
			print_status "INFO" "Discarding SSD: $disk"
			if ! blkdiscard -f "$disk"; then
				print_status "WARNING" "blkdiscard failed, falling back to wipefs"
				wipefs -af "$disk"
			fi
		else
			print_status "INFO" "Wiping rotational disk signatures: $disk"
			wipefs -af "$disk"
		fi
		;;
	esac
}

wipe_disks() {
	local d
	local -a disks

	zpool export -a 2>/dev/null || true
	umount -R "$TARGET_ROOT" 2>/dev/null || true

	mapfile -t disks < <(target_disks)
	for d in "${disks[@]}"; do
		wipe_one "$d"
	done
	udevadm settle
}

prepare_keys() {
	print_status "INFO" "Preparing ZFS key files..."
	(
		umask 077
		printf '%s' "$ZFS_PASS" >"$ZROOT_KEY"
		if [[ -n "$DATA_DISK" ]]; then
			head -c 32 /dev/urandom >"$ZSTORAGE_KEY"
		fi
	)
}

run_disko() {
	print_status "INFO" "Executing disko (${DISKO_REF##*/})..."
	nix run "$DISKO_REF" -- \
		--mode destroy,format,mount \
		--yes-wipe-all-disks \
		--flake "$FLAKE_REF"
}

expect_keylocation() {
	local pool="$1" expected="$2" actual

	actual="$(zfs get -H -o value keylocation "$pool")"
	if [[ "$actual" != "$expected" ]]; then
		die "$pool keylocation is '$actual', expected '$expected'"
	fi
}

verify_pools() {
	expect_keylocation zroot prompt
	if [[ -n "$DATA_DISK" ]]; then
		expect_keylocation zstorage "$ZSTORAGE_KEYLOCATION"
	fi
	if ! mountpoint -q "$PERSIST"; then
		die "$PERSIST is not mounted"
	fi
	print_status "OK" "Pools created, keylocations and mounts look right"
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ╻ ╻
# ┗━┓ ┃ ┣━┫┃╺┓┣╸    ┗━┫
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸     ╹
find_age_backup() {
	local dir name

	if [[ -n "$AGE_KEY_FILE" && -f "$AGE_KEY_FILE" ]]; then
		echo "$AGE_KEY_FILE"
		return 0
	fi
	for dir in "${AGE_SEARCH_DIRS[@]}"; do
		for name in "${AGE_BACKUP_NAMES[@]}"; do
			if [[ -f "${dir}/${name}" ]]; then
				echo "${dir}/${name}"
				return 0
			fi
		done
	done
	return 1
}

paste_age_key() {
	print_status "PROMPT" "Paste the age key, then Ctrl-D:"
	(umask 077 && cat >"$AGE_KEY_TARGET")
}

provision_age_key() {
	local src

	if src="$(find_age_backup)"; then
		print_status "INFO" "Found encrypted age key: $src (enter its passphrase)"
		if ! (umask 077 && age -d -o "$AGE_KEY_TARGET" "$src"); then
			rm -f "$AGE_KEY_TARGET"
			print_status "WARNING" "Decryption failed, falling back to manual paste"
			paste_age_key
		fi
	else
		print_status "WARNING" "No ${AGE_BACKUP_NAMES[*]} found"
		paste_age_key
	fi

	chmod 600 "$AGE_KEY_TARGET"
	if ! grep -q '^AGE-SECRET-KEY-' "$AGE_KEY_TARGET"; then
		die "No AGE-SECRET-KEY line in $AGE_KEY_TARGET"
	fi
	print_status "OK" "sops age key in place"
}

write_password_hash() {
	local user="$1" pass="$2"

	printf '%s' "$pass" | mkpasswd -m yescrypt -s | tr -d '\n' >"${PASSWD_DIR}/${user}"
	chmod 600 "${PASSWD_DIR}/${user}"
}

provision_passwords() {
	install -d -m 700 "$PASSWD_DIR"
	write_password_hash "$USERNAME" "$USER_PASS"
	write_password_hash root "$ROOT_PASS"
	print_status "OK" "Password hashes written"
}

provision_persistent() {
	print_status "INFO" "Provisioning keys and passwords in ${PERSIST}..."
	install -d -m 700 "$(dirname "$AGE_KEY_TARGET")"

	if [[ -n "$DATA_DISK" ]]; then
		install -d -m 700 "$(dirname "$ZSTORAGE_KEY_PERSISTED")"
		install -m 400 "$ZSTORAGE_KEY" "$ZSTORAGE_KEY_PERSISTED"
	fi
	cleanup

	provision_age_key
	provision_passwords
}

regen_hwconfig() {
	local hw="${REPO_DIR}/hosts/${HOST}/_hardware-configuration.nix" old new

	if [[ ! -f "$hw" ]]; then
		print_status "INFO" "No _hardware-configuration.nix for ${HOST}, skipping"
		return 0
	fi

	print_status "INFO" "Regenerating hardware configuration..."
	old="$(mktemp)"
	new="$(mktemp)"
	cp "$hw" "$old"
	nixos-generate-config --show-hardware-config --no-filesystems --root "$TARGET_ROOT" >"$new"
	cp "$new" "$hw"

	if ! (cd "$REPO_DIR" && nix fmt -- "$hw"); then
		cp "$old" "$hw"
		rm -f "$old" "$new"
		die "nix fmt failed on the generated hardware configuration (original restored)"
	fi

	if cmp -s "$old" "$hw"; then
		print_status "OK" "Hardware configuration unchanged"
	else
		diff -u "$old" "$hw" || true
		HW_CHANGED=true
		print_status "WARNING" "Hardware configuration changed (diff above), commit it after first boot"
	fi
	rm -f "$old" "$new"
}

install_system() {
	print_status "INFO" "Installing NixOS (this is the long step)..."
	nixos-install --root "$TARGET_ROOT" --no-root-password --flake "$FLAKE_REF"
}

copy_repo() {
	local dest="${USER_HOME}/nixmania"

	print_status "INFO" "Copying repository to ${dest}"
	install -d -m 700 -o "$USER_UID" -g "$USER_GID" "$USER_HOME"
	mkdir -p "$dest"
	cp -a "${REPO_DIR}/." "${dest}/"
	chown -R "${USER_UID}:${USER_GID}" "$dest"
}

finish() {
	if [[ -n "$DATA_DISK" ]]; then
		print_status "WARNING" "/data is encrypted with a raw key that exists ONLY at /persistent/zfs-keys/zstorage.key"
		if confirm_prompt "Print the key (base64) so you can save a backup?"; then
			echo
			base64 -w0 "$ZSTORAGE_KEY_PERSISTED"
			echo -e "\n"
			read -rp "Press Enter once it is saved..."
		fi
	fi

	umount -R "$TARGET_ROOT" || die "Could not unmount ${TARGET_ROOT}; do not reboot yet"
	zpool export -a || die "zpool export failed; do not reboot yet"
}

# ┏┳┓┏━┓╻┏┓╻
# ┃┃┃┣━┫┃┃┗┫
# ╹ ╹╹ ╹╹╹ ╹
main() {
	trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR
	trap cleanup EXIT

	parse_args "$@"

	stage 1 "System Checks"
	check_root
	check_internet
	check_tools
	pause

	stage 2 "Configuration & Credentials"
	prompt_host
	echo
	first_eval
	echo

	print_status "PROMPT" "Passphrase for ZFS root dataset:"
	prompt_password ZFS_PASS
	echo

	print_status "PROMPT" "Password for user '${USERNAME}':"
	prompt_password USER_PASS
	echo

	print_status "PROMPT" "Password for root:"
	prompt_password ROOT_PASS
	pause

	stage 3 "Pre-Flight Confirmation"
	confirm_destroy

	stage 4 "Execution"
	iso_prep
	if [[ "$WIPE" == true ]]; then
		wipe_disks
	fi
	prepare_keys
	run_disko
	verify_pools
	provision_persistent
	regen_hwconfig
	install_system
	copy_repo
	finish

	echo
	done_banner
	echo
	print_status "OK" "Installation completed. You may now reboot."
	if [[ "$HW_CHANGED" == true ]]; then
		print_status "INFO" "Remember to commit hosts/${HOST}/_hardware-configuration.nix after first boot"
	fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	main "$@"
fi
