{
  flake.modules.nixos.cli_fastfetch = {
    config,
    lib,
    inputs,
    ...
  }: let
    stx = config.lib.stylix.colors;

    boxWidth = 50;
    logoW = 16;
    logoH = 8;
    padTop = 1;
    padLeft = 3;
    padRight = 2;
    textCol = padLeft + logoW + padRight + 1;

    esc = builtins.fromJSON ''"\u001b"'';
    sgr = code: "${esc}[${code}m";
    col = n: "${esc}[${toString n}G";
    rgb = slot: "38;2;${stx."${slot}-rgb-r"};${stx."${slot}-rgb-g"};${stx."${slot}-rgb-b"}";
    fg = slot: sgr (rgb slot);

    white = fg "base07";
    orange = fg "base09";
    reset = sgr "0";

    lb = "${col 1}${white}║";
    rb = "${col boxWidth}${white}║${reset}";

    rule = n: lib.concatStrings (lib.genList (_: "═") n);
    inner = boxWidth - 2;

    border = left: right: {
      type = "custom";
      format = "${col 1}${white}${left}${rule inner}${right}${reset}";
    };
    blank = {
      type = "custom";
      format = "${lb}${rb}";
    };

    row = type: name: accent: format:
      {
        inherit type;
        key = "${lb}${col textCol}${fg accent}${lib.fixedWidthString 3 " " name} ${orange}▸${white} ";
        format = "${white}${format}${rb}";
      }
      // lib.optionalAttrs (type == "memory") {percent.type = ["bar"];};
  in {
    hm.programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          type = "kitty";
          source = "${inputs.self}/assets/pictures/fastfetch/logo.gif";
          width = logoW;
          height = logoH;
          padding = {
            top = padTop;
            left = padLeft;
            right = padRight;
          };
          animationFrame = 0;
        };

        display = {
          separator = "";
          color = {
            keys = "white";
            title = "white";
            output = "white";
          };
          bar = {
            width = 8;
            char = {
              elapsed = "▰";
              total = "▱";
            };
            border = null;
            color = null;
          };
        };

        modules = [
          (border "╔" "╗")
          blank
          {
            type = "title";
            format = "${lb}${col textCol}${fg "base0D"} {user-name}${fg "base0E"}@${fg "base0C"}{host-name}${rb}";
          }
          blank
          (row "os" "os" "base08" "{pretty-name}")
          (row "wm" "wm" "base0B" "{pretty-name}")
          (row "shell" "sh" "base0C" "{pretty-name}")
          (row "uptime" "up" "base0D" "{formatted}")
          (row "memory" "ram" "base0E" "{percentage-bar} {used}")
          blank
          (border "╚" "╝")
        ];
      };
    };
  };
}
