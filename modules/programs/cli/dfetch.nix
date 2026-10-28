{
  flake.modules.nixos.cli_dfetch = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    colors = lib.mapAttrs (_: v: lib.removePrefix "#" v) config.lib.stylix.extended-palette.colors;

    hexLines = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "  [${name}]=\"${value}\"") colors
    );

    dfetch = pkgs.writeShellApplication {
      name = "dfetch";
      runtimeInputs = [pkgs.coreutils pkgs.gnugrep pkgs.ncurses];
      text = ''
        declare -A HEX=(
        ${hexLines}
        )

        bg() { printf '\e[48;2;%d;%d;%dm' "$((16#''${1:0:2}))" "$((16#''${1:2:2}))" "$((16#''${1:4:2}))"; }
        fg() { printf '\e[38;2;%d;%d;%dm' "$((16#''${1:0:2}))" "$((16#''${1:2:2}))" "$((16#''${1:4:2}))"; }
        rst() { printf '\e[0m'; }

        term_w=$(tput cols 2>/dev/null || echo 80)
        grid_w=53
        pad=$(( (term_w - grid_w) / 2 ))
        (( pad < 0 )) && pad=0
        lead=$(printf '%*s' "$pad" "")

        echo
        fg "''${HEX[blue]}"; printf '%s' "$lead"; printf 'SOLARIZED_KYOTO  \n'; rst
        fg "''${HEX[magenta]}"; printf '%s' "$lead"; printf 'An extended solarized theme \n\n'; rst

        print_row() {
          local label=$1; shift
          printf '%s' "$lead"
          fg "''${HEX[fg]}"; printf '%-9s' "$label"; rst
          for k in "$@"; do
            bg "''${HEX[$k]}"; printf '    '; rst
          done
          echo
        }

        print_row "bg/fg" base04 base03 base02 base01 base00 fg base0 base1 base2 base3 base4
        echo

        for accent in red orange yellow green cyan blue magenta violet; do
          keys=()
          for step in 50 100 200 300 400 500 600 700 800 900 950; do
            keys+=("''${accent}''${step}")
          done
          print_row "$accent" "''${keys[@]}"
        done
        echo

        info_row() {
          local label=$1 value=$2 key=$3
          printf '%s' "$lead"
          fg "''${HEX[$key]}"; printf '%-11s' "$label"; rst
          fg "''${HEX[fg]}"; printf '%s\n' "$value"; rst
        }

        kernel=$(uname -r 2>/dev/null || echo "n/a")
        gen=$(readlink /nix/var/nix/profiles/system 2>/dev/null | grep -oE '[0-9]+' | head -n1 || echo "")
        gen=''${gen:-n/a}
        shell_name=$(basename "''${SHELL:-n/a}")
        os_name=$(grep -m1 '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d'"' -f2)
        os_name=''${os_name:-n/a}
        if [ -r /proc/uptime ]; then
          secs=$(cut -d. -f1 /proc/uptime)
          days=$(( secs / 86400 ))
          hours=$(( (secs % 86400) / 3600 ))
          mins=$(( (secs % 3600) / 60 ))
          uptime_str=""
          [ "$days" -gt 0 ] && uptime_str="''${uptime_str}''${days}d "
          [ "$hours" -gt 0 ] && uptime_str="''${uptime_str}''${hours}h "
          uptime_str="''${uptime_str}''${mins}m"
        else
          uptime_str="n/a"
        fi
        info_row "host" "${config.networking.hostName}" red
        info_row "os" "$os_name" orange
        info_row "kernel" "$kernel" yellow
        info_row "generation" "#$gen" green
        info_row "nix" "${pkgs.nix.version}" cyan
        info_row "shell" "$shell_name" blue
        info_row "uptime" "$uptime_str" magenta
        echo
      '';
    };
  in {
    hm.home.packages = [dfetch];
  };
}
