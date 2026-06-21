{
  flake.modules.nixos.cli_fastfetch = {confDir, ...}: {
    hm.programs.fastfetch = {
      enable = true;
      settings = let
        color = {
          accent1 = "cyan";
          accent2 = "blue";
          accent3 = "white";
          accent4 = "cyan";
          accent5 = "white";
        };
      in {
        logo = {
          type = "kitty";
          source = "${confDir}/assets/pictures/logos/nixos.png";
          width = 22;
          height = 10;
          padding = {
            top = 0;
            right = 2;
          };
        };
        display = {
          separator = " • ";
          color = {
            "title" = color.accent3;
            "keys" = color.accent5;
          };
        };
        modules = [
          {
            type = "title";
            format = " {user-name-colored}@{host-name-colored}";
            color = {
              user = color.accent4;
              at = color.accent5;
              host = color.accent2;
            };
          }
          "break"
          {
            type = "os";
            key = "{#31}  ";
            format = "{pretty-name}";
          }
          {
            type = "kernel";
            key = "{#32}  ";
            format = "{release}";
          }
          {
            type = "uptime";
            key = "{#33}  ";
          }
          {
            type = "shell";
            key = "{#34}  ";
            format = "{pretty-name} {version}";
          }
          {
            type = "wm";
            key = "{#35}  ";
            format = "{pretty-name} {version}";
          }
          {
            type = "custom";
            format = " {#37}▂▂ {#36}▂▂ {#35}▂▂ {#34}▂▂ {#33}▂▂ {#32}▂▂ {#31}▂▂";
          }
        ];
      };
    };
  };
}
