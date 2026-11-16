{
  flake.modules.nixos.cli_yazi = {
    config,
    lib,
    ...
  }: {
    hm.programs.yazi.theme = with config.lib.stylix.colors; let
      i = units: builtins.fromJSON ''"${lib.concatMapStrings (u: "\\u${u}") units}"'';
      dir = name: text: fg: {
        inherit name text;
        fg = "#${fg}";
      };
      cond = cond: text: fg: {
        "if" = cond;
        inherit text;
        fg = "#${fg}";
      };
    in {
      indicator.padding = {
        open = i ["2588"];
        close = i ["2588"];
      };

      tabs = {
        sep_inner = {
          open = i ["e0b6"];
          close = i ["e0b4"];
        };
        sep_outer = {
          open = i ["e0b6"];
          close = i ["e0b4"];
        };
      };

      status = {
        sep_left = {
          open = i ["e0b6"];
          close = i ["e0b4"];
        };
        sep_right = {
          open = i ["e0b6"];
          close = i ["e0b4"];
        };
      };

      which.separator = " ➸ ";

      icon = {
        globs = [];
        conds = lib.mkForce [
          (cond "orphan" (i ["f127"]) base05)
          (cond "link" (i ["f481"]) base04)
          (cond "block" (i ["f0c9"]) base0A)
          (cond "char" (i ["f1c0"]) base0A)
          (cond "fifo" (i ["f1d1"]) base0A)
          (cond "sock" (i ["f1e4"]) base0A)
          (cond "sticky" (i ["f08d"]) base0A)
          (cond "dummy" (i ["f057"]) base08)
          (cond "dir" (i ["eaf7"]) base0D)
          (cond "exec" (i ["f489"]) base0B)
          (cond "!dir" (i ["f15b"]) base05)
        ];
        dirs = lib.mkForce [
          (dir ".config" (i ["e5fc"]) base0F)
          (dir ".git" (i ["e5fb"]) base0E)
          (dir ".github" (i ["e5fd"]) base0D)
          (dir ".npm" (i ["e5fa"]) base0D)
          (dir "Desktop" (i ["f108"]) base0D)
          (dir "Documents" (i ["db80" "de4e"]) base0D)
          (dir "Downloads" (i ["db80" "de4d"]) base0D)
          (dir "Movies" (i ["db80" "de4f"]) base0D)
          (dir "Music" (i ["db84" "df59"]) base0D)
          (dir "nixmania" (i ["db84" "dc7f"]) base0D)
          (dir "Pictures" (i ["db80" "de4f"]) base0D)
          (dir "Projects" (i ["db86" "ddfc"]) base0D)
          (dir "Public" (i ["db85" "df8a"]) base0D)
          (dir "Templates" (i ["e5ff"]) base0D)
          (dir "Videos" (i ["db86" "ddfa"]) base0D)
        ];
      };
    };
  };
}
