{
  flake.modules.nixos.cli_dfetch = {
    config,
    pkgs,
    ...
  }: let
    colors = config.lib.stylix.colors;

    dfetch = pkgs.writeShellApplication {
      name = "dfetch";
      runtimeInputs = [pkgs.coreutils pkgs.gnugrep];
      text = ''
        declare -A HEX=(
          [base00]="${colors.base00}" [base01]="${colors.base01}" [base02]="${colors.base02}" [base03]="${colors.base03}"
          [base04]="${colors.base04}" [base05]="${colors.base05}" [base06]="${colors.base06}" [base07]="${colors.base07}"
          [base08]="${colors.base08}" [base09]="${colors.base09}" [base0A]="${colors.base0A}" [base0B]="${colors.base0B}"
          [base0C]="${colors.base0C}" [base0D]="${colors.base0D}" [base0E]="${colors.base0E}" [base0F]="${colors.base0F}"
        )

        order=(base00 base01 base02 base03 base04 base05 base06 base07
               base08 base09 base0A base0B base0C base0D base0E base0F)

        bg() { printf '\e[48;2;%d;%d;%dm' "$((16#''${1:0:2}))" "$((16#''${1:2:2}))" "$((16#''${1:4:2}))"; }
        fg() { printf '\e[38;2;%d;%d;%dm' "$((16#''${1:0:2}))" "$((16#''${1:2:2}))" "$((16#''${1:4:2}))"; }
        rst() { printf '\e[0m'; }

        BLOCK="      "
        term_w=$(tput cols 2>/dev/null || echo 80)
        pad=$(( (term_w - 62) / 2 ))
        (( pad < 0 )) && pad=0
        lead=$(printf '%*s' "$pad" "")

        echo
        fg "''${HEX[base0D]}"; printf '%s' "$lead"; printf '  Y O I Y A M I (宵闇)\n'; rst
        fg "''${HEX[base04]}"; printf '%s' "$lead"; printf '  A DUSK-TONED PASTEL BASE16 SCHEME\n\n'; rst

        printf '%s' "$lead"
        for k in base00 base01 base02 base03 base04 base05 base06 base07; do
          bg "''${HEX[$k]}"; printf '%s' "$BLOCK"
        done
        rst
        echo

        printf '%s' "$lead"
        for k in base08 base09 base0A base0B base0C base0D base0E base0F; do
          bg "''${HEX[$k]}"; printf '%s' "$BLOCK"
        done
        rst
        echo
        echo

        swatch() {
          local k=$1
          bg "''${HEX[$k]}"; printf '  '; rst
          fg "''${HEX[$k]}"; printf ' %-7s' "$k"; rst
          fg "''${HEX[base04]}"; printf '#%-8s' "''${HEX[$k]}"; rst
        }

        for row in 0 1 2 3 4 5 6 7; do
          left=''${order[$row]}
          right=''${order[$((row+8))]}
          printf '%s' "$lead"
          swatch "$left"
          printf '   '
          swatch "$right"
          printf '\n'
        done
        echo

        info_row() {
          local label=$1 value=$2 accent=$3
          printf '%s' "$lead"
          fg "''${HEX[$accent]}"; printf '%-11s' "$label"; rst
          fg "''${HEX[base05]}"; printf '%s\n' "$value"; rst
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

        info_row "host" "${config.networking.hostName}" base08
        info_row "os" "$os_name" base09
        info_row "kernel" "$kernel" base0A
        info_row "generation" "#$gen" base0B
        info_row "nix" "${pkgs.nix.version}" base0C
        info_row "shell" "$shell_name" base0D
        info_row "uptime" "$uptime_str" base0E
        echo
      '';
    };
  in {
    hm.home.packages = [dfetch];
  };
}
