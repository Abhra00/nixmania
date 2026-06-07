{
  flake.modules.nixos.cli_fastfetch = {
    hm.programs.fastfetch = {
      enable = true;
      settings = let
        esc = builtins.fromJSON ''"\u001b"'';
        color = {
          accent1 = "magenta";
          accent2 = "blue";
          accent3 = "blue";
          accent4 = "magenta";
          accent5 = "white";
        };
      in {
        logo = {
          type = "data";
          source = ''
                      $1▗▄▄▄       $2▗▄▄▄▄    ▄▄▄▖
                      $1▜███▙       $2▜███▙  ▟███▛
                       $1▜███▙       $2▜███▙▟███▛
                        $1▜███▙       $2▜██████▛
                 $1▟█████████████████▙ $2▜████▛     $1▟▙
                $1▟███████████████████▙ $2▜███▙    $1▟██▙
                       $2▄▄▄▄▖           $2▜███▙  $1▟███▛
                      $2▟███▛             $2▜██▛ $1▟███▛
                     $2▟███▛               $2▜▛ $1▟███▛
            $2▟███████████▛                  $1▟██████████▙
            $2▜██████████▛                  $1▟███████████▛
                  $2▟███▛ $1▟▙               $1▟███▛
                 $2▟███▛ $1▟██▙             $1▟███▛
                $2▟███▛  $1▜███▙           $1▝▀▀▀▀
                $2▜██▛    $1▜███▙ $2▜██████████████████▛
                 $2▜▛     $1▟████▙ $2▜████████████████▛
                       $1▟██████▙         $2▜███▙
                      $1▟███▛▜███▙         $2▜███▙
                     $1▟███▛  ▜███▙         $2▜███▙
                     $1▝▀▀▀    ▀▀▀▀▘         $2▀▀▀▘
          '';
          position = "left";
          color = {
            "1" = color.accent1;
            "2" = color.accent2;
          };
        };
        display = {
          separator = "";
          constants = [
            "${esc}[s${esc}[52C${esc}[0m│${esc}[u"
            "${esc}[31m · ${esc}[0m"
          ];
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
          {
            type = "title";
            format = "{user-name-colored}@{host-name-colored}";
            color = {
              user = color.accent3;
              at = color.accent5;
              host = color.accent4;
            };
          }
          "break"
          {
            type = "custom";
            format = "┌────「 {#1}{#35}OS{#} 」──────────────────────────────────────────────┐";
          }
          {
            type = "os";
            key = "{#}│{#31} {icon} {$2}{$1}";
            format = "{pretty-name}";
          }
          {
            type = "kernel";
            key = "{#}│{#32} {icon} {$2}{$1}";
          }
          {
            type = "uptime";
            key = "{#}│{#33} {icon} {$2}{$1}";
          }
          {
            type = "custom";
            format = "└──────────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌────「 {#1}{#34}HW{#} 」──────────────────────────────────────────────┐";
          }
          {
            type = "cpu";
            key = "{#}│{#34} {icon} {$2}{$1}";
            format = "{name}";
            temp = true;
          }
          {
            type = "gpu";
            key = "{#}│{#35} {icon} {$2}{$1}";
            format = "{name}";
            driverSpecific = true;
          }
          {
            type = "memory";
            key = "{#}│{#36} {icon} {$2}{$1}";
            format = "{percentage-bar} {used} / {total}";
          }
          {
            type = "custom";
            format = "└──────────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌────「 {#1}{#33}SW{#} 」──────────────────────────────────────────────┐";
          }
          {
            type = "packages";
            key = "{#}│{#31}  {$2}{$1}";
          }
          {
            type = "wm";
            key = "{#}│{#32} {icon} {$2}{$1}";
            format = "{pretty-name}";
          }
          {
            type = "terminal";
            key = "{#}│{#33}  {$2}{$1}";
            format = "{pretty-name} {version}   {#37} {#36} {#35} {#34} {#33} {#32} {#31}";
          }
          {
            type = "shell";
            key = "{#}│{#34} {icon} {$2}{$1}";
            format = "{pretty-name}";
          }
          {
            type = "custom";
            format = "└──────────────────────────────────────────────────────────┘";
          }
        ];
      };
    };
  };
}
