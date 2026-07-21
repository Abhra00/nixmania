{
  flake.modules.nixos.cli_yazi = {config, ...}: {
    hm.programs.yazi = let
      colors = config.lib.stylix.colors;
    in {
      theme = {
        indicator = {
          padding = {
            open = "█";
            close = "█";
          };
        };
        tabs = {
          sep_inner = {
            open = "█";
            close = "█";
          };
          sep_outer = {
            open = "█";
            close = "█";
          };
        };
        status = {
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };
        };
        which = {
          separator = " ➸ ";
        };
        icon = {
          globs = [];
          conds = [
            {
              "if" = "dir";
              text = "";
              fg = "#${colors.base0D}";
            }
          ];
          dirs = [
            {
              name = ".config";
              text = "";
              fg = "#${colors.base0F}";
            }
            {
              name = ".git";
              text = "";
              fg = "#${colors.base0E}";
            }
            {
              name = ".github";
              text = "";
              fg = "#${colors.base0D}";
            }
            {
              name = ".npm";
              text = "";
              fg = "#${colors.base0D}";
            }
            {
              name = "Desktop";
              text = "";
              fg = "#${colors.base0D}";
            }

            {
              name = "Documents";
              text = "󰉎";
              fg = "#${colors.base0D}";
            }
            {
              name = "Downloads";
              text = "󰉍";
              fg = "#${colors.base0D}";
            }
            {
              name = "Movies";
              text = "󰉏";
              fg = "#${colors.base0D}";
            }
            {
              name = "Music";
              text = "󱍙";
              fg = "#${colors.base0D}";
            }

            {
              name = "nixmania";
              text = "";
              fg = "#${colors.base0D}";
            }
            {
              name = "Pictures";
              text = "󰉏";
              fg = "#${colors.base0D}";
            }

            {
              name = "Projects";
              text = "󱧼";
              fg = "#${colors.base0D}";
            }
            {
              name = "Public";
              text = "󱞊";
              fg = "#${colors.base0D}";
            }
            {
              name = "Templates";
              text = "";
              fg = "#${colors.base0D}";
            }
            {
              name = "Videos";
              text = "󱧺";
              fg = "#${colors.base0D}";
            }
          ];
        };
      };
    };
  };
}
