{
  flake.modules.nixos.cli_fastfetch = {
    hm.programs.fastfetch = {
      enable = true;
      settings = let
        esc = builtins.fromJSON ''"\u001b"'';
        c = code: "${esc}[${code}m";
        reset = c "0";
        red = "31";
        green = "32";
        gold = "1;33";
        blue = "34";
        magenta = "35";
        cyan = "36";
        white = "97";
        grey = "90";
        magentaItalic = "3;35";
      in {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo.type = "none";
        display = {
          separator = " ${c grey}│${reset} ";
          color.keys = "white";
          brightColor = false;
        };
        modules = [
          "break"
          {
            type = "custom";
            format = "  ${c grey}◤━━━━━━━━━━━━━━━━━━━━━━━▶${reset}";
          }
          {
            type = "custom";
            format = "      ${c "1;${red}"}N${c green} I ${c gold}X${c blue} M ${c cyan}A${c magenta} N ${c red}I${c green} A${reset}";
          }
          {
            type = "custom";
            format = "  ${c grey}◣━━━━━━━━━━━━━━━━━━━━━━━▶${reset}";
          }
          "break"
          {
            type = "title";
            format = "  ${c red}{user-name}${c gold} @ ${c cyan}{host-name}${reset}";
          }
          "break"
          {
            type = "os";
            key = "    os";
            format = "${c white}{name}${reset}";
            keyColor = red;
          }
          {
            type = "kernel";
            key = "   krn";
            format = "${c white}{release}${reset}";
            keyColor = green;
          }
          {
            type = "uptime";
            key = "    up";
            keyColor = gold;
          }
          {
            type = "wm";
            key = "    wm";
            format = "${c white}{pretty-name}${reset}";
            keyColor = blue;
          }
          {
            type = "shell";
            key = "    sh";
            format = "${c white}{pretty-name}${reset}";
            keyColor = magenta;
          }
          {
            type = "terminal";
            key = "   tty";
            format = "${c white}{pretty-name}${reset}";
            keyColor = cyan;
          }
          {
            type = "packages";
            key = "   pkg";
            format = "${c white}{all}${reset}";
            keyColor = red;
          }
          {
            type = "memory";
            key = "   ram";
            format = "${c white}{used} / {total}${reset}";
            keyColor = green;
            percent.type = 0;
          }
          {
            type = "swap";
            key = "  zram";
            format = "${c white}{used} / {total}${reset}";
            keyColor = blue;
            percent.type = 0;
          }
          "break"
          {
            type = "custom";
            format = "  ${c grey}◤━━━━━━━━━━━━━━━━━━━━━━━►${reset}";
          }
          {
            type = "custom";
            format = "  ${c magentaItalic}NIX does it all!! Hail NIX!!${reset}";
          }
          "break"
        ];
      };
    };
  };
}
