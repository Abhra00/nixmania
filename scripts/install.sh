#!/usr/bin/env bash
# NIXMANIA installer: ZFS (native encryption) + rollback root + preservation.
# usage: scripts/install.sh [host] [--wipe]
set -Eeuo pipefail

# Repo root is the parent of scripts
REPO_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")" && readonly REPO_DIR
: "${TARGET_ROOT:=/mnt}"
readonly TARGET_ROOT
readonly PERSIST="${TARGET_ROOT}/persistent"
readonly USERNAME="bugs"
readonly USER_UID=1000
readonly USER_GID=100

readonly B="\033[1m"    # Bold
readonly R="\033[1;31m" # Bold red
readonly Y="\033[1;33m" # Bold yellow
readonly G="\033[1;32m" # Bold green
readonly C="\033[1;36m" # Bold cyan
readonly M="\033[1;35m" # Bold magenta
readonly D="\033[2m"    # Dim
readonly RST="\033[0m"  # Reset

HOST=""
WIPE=false
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
    rm -f /tmp/zroot.key /tmp/zstorage.key
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ╺┓
# ┗━┓ ┃ ┣━┫┃╺┓┣╸     ┃
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸   ╺┻╸
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_status "OK" "Running as root"
    else
        die "Must be run as root"
    fi
}

check_internet() {
    if curl -fsS --max-time 10 -o /dev/null https://cache.nixos.org/nix-cache-info; then
        print_status "OK" "Internet connection active"
    else
        die "No internet connection (cache.nixos.org unreachable)"
    fi
}

check_tools() {
    local cmd
    for cmd in git curl mkpasswd lsblk zramctl blkdiscard wipefs nix nixos-generate-config nixos-install; do
        if command -v "$cmd" >/dev/null 2>&1; then
            print_status "OK" "$cmd is available"
        else
            die "Required tool '$cmd' is missing"
        fi
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
    local hosts=() dir choice h

    for dir in "${REPO_DIR}"/hosts/*/; do
        [[ -d "$dir" ]] || continue
        if [[ -f "${dir}configuration.nix" && -f "${dir}disko.nix" ]]; then
            hosts+=("$(basename "$dir")")
        fi
    done

    if [[ ${#hosts[@]} -eq 0 ]]; then
        die "No valid host configurations found in ${REPO_DIR}/hosts/"
    fi

    if [[ -n "$HOST" ]]; then
        for h in "${hosts[@]}"; do
            if [[ "$h" == "$HOST" ]]; then
                print_status "OK" "Using target host: ${B}${HOST}${RST}"
                return 0
            fi
        done
        die "Host '$HOST' not found in hosts/ (have: ${hosts[*]})"
    fi

    print_status "PROMPT" "Available hosts:"
    for i in "${!hosts[@]}"; do
        echo -e "${B}$((i + 1))${RST} ${D}|${RST} ${hosts[i]}"
    done

    while true; do
        input_prompt "Pick host number: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#hosts[@]})); then
            HOST="${hosts[choice - 1]}"
            return 0
        fi
        print_status "FAILED" "Invalid selection"
    done
}

# Reads the disks from the flake
resolve_disks() {
    local attr="${REPO_DIR}#nixosConfigurations.${HOST}.config.storage.zfs"
    local d

    print_status "INFO" "Reading disk layout from the flake (first eval fetches inputs)..."
    MAIN_DISK="$(nix eval --raw "${attr}.device")"
    DATA_DISK="$(nix eval --raw --apply 'x: if x == null then "" else x' "${attr}.dataDevice")"

    for d in "$MAIN_DISK" "$DATA_DISK"; do
        if [[ -n "$d" && ! -e "$d" ]]; then
            die "Disk path from the flake does not exist on this machine: $d"
        fi
    done
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

        if [[ "$pass" == "$confirm" && ${#pass} -ge 8 ]]; then
            printf -v "$var_name" '%s' "$pass"
            return 0
        fi
        print_status "FAILED" "Passwords do not match or are shorter than 8 characters"
    done
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ┏━┓
# ┗━┓ ┃ ┣━┫┃╺┓┣╸    ╺━┫
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸   ┗━┛
confirm_destroy() {
    local ans real=() d

    for d in "$MAIN_DISK" "$DATA_DISK"; do
        if [[ -n "$d" ]]; then
            real+=("$(readlink -f "$d")")
        fi
    done

    print_status "INFO" "Target host: ${B}${HOST}${RST}"
    print_status "INFO" "Secure wipe first (--wipe): ${B}${WIPE}${RST}"
    print_status "WARNING" "EVERYTHING on these disks is destroyed, with or without --wipe:"
    lsblk -d -o NAME,SIZE,MODEL,SERIAL,ROTA "${real[@]}"
    echo
    input_prompt "Type the hostname (${HOST}) to continue: " ans
    if [[ "$ans" != "$HOST" ]]; then
        print_status "INFO" "Aborted."
        exit 1
    fi
}

iso_prep() {
    print_status "INFO" "Configuring ISO environment (zram swap, ZFS ARC cap)..."
    if ! swapon --show=NAME --noheadings | grep -q zram; then
        modprobe zram
        local zdev
        zdev="$(zramctl --find --size 20G --algorithm zstd)"
        mkswap "$zdev" >/dev/null
        swapon --priority 100 "$zdev"
    fi
    modprobe zfs || die "Could not load the zfs kernel module on this ISO"
    if [[ -w /sys/module/zfs/parameters/zfs_arc_max ]]; then
        echo 2147483648 >/sys/module/zfs/parameters/zfs_arc_max
    fi
}

wipe_one() {
    local real
    real="$(readlink -f "$1")"

    case "$real" in
    /dev/nvme*)
        print_status "INFO" "NVMe user-data erase (--ses=1): $real"
        if ! nvme format "$real" --ses=1 --force; then
            print_status "WARNING" "nvme format failed, falling back to blkdiscard"
            blkdiscard -f "$real"
        fi
        ;;
    *)
        if [[ "$(lsblk -dno ROTA "$real" | tr -d '[:space:]')" == "0" ]]; then
            print_status "INFO" "Discarding SSD: $real"
            if ! blkdiscard -f "$real"; then
                print_status "WARNING" "blkdiscard failed, falling back to wipefs"
                wipefs -af "$real"
            fi
        else
            print_status "INFO" "Wiping rotational disk signatures: $real"
            wipefs -af "$real"
        fi
        ;;
    esac
}

wipe_disks() {
    local d
    zpool export -a 2>/dev/null || true
    umount -R "$TARGET_ROOT" 2>/dev/null || true

    for d in "$MAIN_DISK" "$DATA_DISK"; do
        if [[ -n "$d" ]]; then
            wipe_one "$d"
        fi
    done
    udevadm settle
}

# Keys must exist BEFORE disko runs: the pools are created with
# keylocation=file:///tmp/*.key and only afterwards pointed elsewhere
prepare_keys() {
    print_status "INFO" "Preparing ZFS key files..."
    (
        umask 077
        printf '%s' "$ZFS_PASS" >/tmp/zroot.key
        if [[ -n "$DATA_DISK" ]]; then
            head -c 32 /dev/urandom >/tmp/zstorage.key
        fi
    )
}

run_disko() {
    local rev ref="github:nix-community/disko/latest"

    # Use the disko revision pinned in flake.lock
    rev="$(nix eval --raw --impure --expr \
        "(builtins.fromJSON (builtins.readFile \"${REPO_DIR}/flake.lock\")).nodes.disko.locked.rev" \
        2>/dev/null || true)"
    if [[ -n "$rev" ]]; then
        ref="github:nix-community/disko/${rev}"
    else
        print_status "WARNING" "Could not read disko rev from flake.lock, using disko/latest"
    fi

    print_status "INFO" "Executing disko (${ref##*/})..."
    nix run "$ref" -- \
        --mode destroy,format,mount \
        --yes-wipe-all-disks \
        --flake "${REPO_DIR}#${HOST}"
}

# Verify the pools
verify_pools() {
    local kl
    kl="$(zfs get -H -o value keylocation zroot)"
    [[ "$kl" == "prompt" ]] || die "zroot keylocation is '$kl', expected 'prompt'"

    if [[ -n "$DATA_DISK" ]]; then
        kl="$(zfs get -H -o value keylocation zstorage)"
        [[ "$kl" == "file:///persistent/zfs-keys/zstorage.key" ]] ||
            die "zstorage keylocation is '$kl', expected file:///persistent/zfs-keys/zstorage.key"
    fi
    mountpoint -q "$PERSIST" || die "$PERSIST is not mounted"
    print_status "OK" "Pools created, keylocations and mounts look right"
}

# ┏━┓╺┳╸┏━┓┏━╸┏━╸   ╻ ╻
# ┗━┓ ┃ ┣━┫┃╺┓┣╸    ┗━┫
# ┗━┛ ╹ ╹ ╹┗━┛┗━╸     ╹
find_age_backup() {
    local dir name
    if [[ -n "${AGE_KEY_FILE:-}" && -f "$AGE_KEY_FILE" ]]; then
        echo "$AGE_KEY_FILE"
        return 0
    fi
    for dir in /home/nixos/Downloads /home/nixos /root/Downloads /root "$REPO_DIR" "$PWD"; do
        for name in key.txt.age key.age; do
            if [[ -f "${dir}/${name}" ]]; then
                echo "${dir}/${name}"
                return 0
            fi
        done
    done
    return 1
}

provision_age_key() {
    local target="${PERSIST}/var/lib/sops-nix/key.txt" src

    if src="$(find_age_backup)"; then
        print_status "INFO" "Found encrypted age key: $src (enter its passphrase)"
        if ! (umask 077 && age -d -o "$target" "$src"); then
            rm -f "$target"
            print_status "WARNING" "Decryption failed. Falling back to manual paste."
            print_status "PROMPT" "Paste the age key, then Ctrl-D:"
            (umask 077 && cat >"$target")
        fi
    else
        print_status "PROMPT" "No key.txt.age / key.age found. Paste the age key, then Ctrl-D:"
        (umask 077 && cat >"$target")
    fi

    chmod 600 "$target"
    grep -q '^AGE-SECRET-KEY-' "$target" || die "No AGE-SECRET-KEY line in $target"
    print_status "OK" "sops age key in place"
}

provision_passwords() {
    local dir="${PERSIST}/passwd"
    install -d -m 700 "$dir"
    printf '%s' "$USER_PASS" | mkpasswd -m yescrypt -s | tr -d '\n' >"${dir}/${USERNAME}"
    printf '%s' "$ROOT_PASS" | mkpasswd -m yescrypt -s | tr -d '\n' >"${dir}/root"
    chmod 600 "${dir}/${USERNAME}" "${dir}/root"
    print_status "OK" "Password hashes written"
}

provision_persistent() {
    print_status "INFO" "Provisioning keys and passwords in ${PERSIST}..."
    install -d -m 700 "${PERSIST}/var/lib/sops-nix"

    if [[ -n "$DATA_DISK" ]]; then
        install -d -m 700 "${PERSIST}/zfs-keys"
        install -m 400 /tmp/zstorage.key "${PERSIST}/zfs-keys/zstorage.key"
    fi
    rm -f /tmp/zroot.key /tmp/zstorage.key

    provision_age_key
    provision_passwords
}

regen_hwconfig() {
    local hw="${REPO_DIR}/hosts/${HOST}/_hardware-configuration.nix" tmp

    if [[ ! -f "$hw" ]]; then
        print_status "INFO" "No _hardware-configuration.nix for ${HOST}, skipping"
        return 0
    fi

    print_status "INFO" "Regenerating hardware configuration..."
    tmp="$(mktemp)"
    nixos-generate-config --show-hardware-config --no-filesystems --root "$TARGET_ROOT" >"$tmp"

    if cmp -s "$tmp" "$hw"; then
        print_status "OK" "Hardware configuration unchanged"
    else
        diff -u "$hw" "$tmp" || true
        cat "$tmp" >"$hw"
        HW_CHANGED=true
        print_status "WARNING" "Hardware configuration changed (diff above), commit it after first boot"
    fi
    rm -f "$tmp"
}

install_system() {
    print_status "INFO" "Installing NixOS (this is the long step)..."
    nixos-install --no-root-password --flake "${REPO_DIR}#${HOST}"
}

copy_repo() {
    local home="${PERSIST}/home/${USERNAME}"
    local dest="${home}/nixmania"

    print_status "INFO" "Copying repository to ${dest}"
    install -d -m 700 -o "$USER_UID" -g "$USER_GID" "$home"
    mkdir -p "$dest"
    cp -a "${REPO_DIR}/." "${dest}/"
    chown -R "${USER_UID}:${USER_GID}" "$dest"
}

finish() {
    if [[ -n "$DATA_DISK" ]]; then
        print_status "WARNING" "/data is encrypted with a raw key that exists ONLY at /persistent/zfs-keys/zstorage.key"
        if confirm_prompt "Print the key (base64) so you can save a backup?"; then
            echo
            base64 -w0 "${PERSIST}/zfs-keys/zstorage.key"
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
    export NIX_CONFIG="extra-experimental-features = nix-command flakes pipe-operators"
    trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR
    trap cleanup EXIT

    parse_args "$@"

    # Stage 1 - Checks
    clear && main_banner
    echo -e "${D}Stage 1 - System Checks${RST}" && echo
    check_root
    check_internet
    check_tools

    echo && read -rp "$(echo -e "${D}Press Enter to continue...${RST}")"

    # Stage 2 - Prompts
    clear && main_banner
    echo -e "${D}Stage 2 - Configuration & Credentials${RST}" && echo
    prompt_host && echo
    resolve_disks && echo

    print_status "PROMPT" "Passphrase for ZFS root dataset:"
    prompt_password ZFS_PASS && echo

    print_status "PROMPT" "Password for user '${USERNAME}':"
    prompt_password USER_PASS && echo

    print_status "PROMPT" "Password for root:"
    prompt_password ROOT_PASS

    echo && read -rp "$(echo -e "${D}Press Enter to continue...${RST}")"

    # Stage 3 - Confirmation
    clear && main_banner
    echo -e "${D}Stage 3 - Pre-Flight Confirmation${RST}" && echo
    confirm_destroy

    # Stage 4 - Execution
    clear && main_banner
    echo -e "${D}Stage 4 - Execution${RST}" && echo

    iso_prep
    if $WIPE; then
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

    echo && done_banner && echo
    print_status "OK" "Installation completed. You may now reboot."
    if $HW_CHANGED; then
        print_status "INFO" "Remember to commit hosts/${HOST}/_hardware-configuration.nix after first boot"
    fi
}

# For testing
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
