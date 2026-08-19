{
  flake.modules.nixos.cli_fastfetch = {
    hm.programs.fastfetch = {
      enable = true;

      settings = let
        color = {
          accent1 = "blue"; # Main part of the logo
          accent2 = "green"; # 2nd part of the logo
          accent3 = "green"; # Even head keys, title (user)
          accent4 = "blue"; # Odd head keys, title (host)
          accent5 = "white"; # Sub-keys, title (@)
        };
      in {
        logo = {
          type = "data";
          source = ''
            $1          ▗▄▄▄       $2.*#&.    ,~=,
            $1          ▜███▙       $2&*+)^  %*^@*
            $1           ▜███▙       $2>=-@\/%*$)
            $1            ▜███▙       $2}(!-)$^]
            $1     ▟█████████████████▙ $2&(#@)/     $1▟▙
            $1    ▟███████████████████▙ $2$]<$\    $1▟██▙
            $2           ,___,           !)::&  $1▟███▛
            $2          [$*@#             %#!$ $1▟███▛
            $2         &*%!^               \/ $1▟███▛
            $2/)(*&!#$_#>)*                  $1▟██████████▙
            $2\!@#*@#%<>?&                  $1▟███████████▛
            $2      *}^#* $1▟▙               ▟███▛
            $2     &[!@) $1▟██▙             ▟███▛
            $2    /#$)$  $1▜███▙           ▝▀▀▀▀
            $2    <][(    $1▜███▙ $2%&!~)$&!_)$*!@#$(<>/
            $2     ^@     $1▟████▙ $2^?><!#$!(*&%!_%^)/
            $1           ▟██████▙       $2*(!)\
            $1          ▟███▛▜███▙       $2{>@%!
            $1         ▟███▛  ▜███▙       $2&^#$|
            $1         ▝▀▀▀    ▀▀▀▀▘       $2"*="
          '';
          position = "left";
          color = {
            "1" = color.accent1;
            "2" = color.accent2;
          };
        };

        display = {
          separator = " · ";
          color = {
            "title" = color.accent3;
            "keys" = color.accent5;
          };
          bar = {
            width = 10;
            char.elapsed = "■";
            char.total = "─";
          };
          percent = {
            type = ["num" "bar"];
          };
        };

        modules = [
          # Title
          {
            type = "title";
            format = "{user-name-colored}@{host-name-colored}";
            color = {
              user = color.accent3;
              at = color.accent5;
              host = color.accent4;
            };
          }

          # Separator
          "custom"

          # System Info
          {
            key = "OS";
            keyColor = color.accent4;
            type = "os";
            format = "{pretty-name}";
          }
          {
            key = "├ krnl";
            type = "kernel";
          }
          {
            key = "├ usage ";
            type = "disk";
            percent = {
              type = 3;
            };
          }
          {
            key = "└ up  ";
            type = "uptime";
          }

          # Separator
          "custom"

          # Hardware Info
          {
            key = "PC";
            keyColor = color.accent3;
            type = "title";
            format = "{host-name}";
          }
          {
            key = "├ host";
            type = "host";
            format = "{family}";
          }
          {
            key = "├ cpu ";
            type = "cpu";
            format = "{name} @ {freq-max} - {temperature}";
            temp = true;
          }
          {
            key = "├ gpu ";
            type = "gpu";
            format = "{name} @ {frequency} - {#32}{core-usage-num}";
            driverSpecific = true;
          }
          {
            key = "├ ram ";
            type = "memory";
            format = "{percentage-bar} {used} / {total} - {#32}{percentage}";
          }
          {
            key = "└ swap";
            type = "swap";
            format = "{percentage-bar} {used} / {total} - {#32}{percentage}";
          }

          # Separator
          "custom"

          # Software Info
          {
            key = "PKGS";
            keyColor = color.accent4;
            type = "packages";
          }
          {
            key = "├ de  ";
            type = "de";
            format = "{pretty-name}";
          }
          {
            key = "├ wm  ";
            type = "wm";
            format = "{pretty-name}";
          }
          {
            key = "├ term";
            type = "terminal";
            format = "{pretty-name} {version} {#37}#{#36}#{#35}#{#34}#{#33}#{#32}#{#31}#";
          }
          {
            key = "├ sh  ";
            type = "shell";
          }
          {
            key = "└ edit";
            type = "editor";
          }
        ];
      };
    };
  };
}
