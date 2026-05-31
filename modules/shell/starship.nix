{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          ''[ ](purple)''
          "$username"
          ''[ in ](base0F)''
          "$directory"
          "$git_branch"
          "$git_status"
          "$jobs"
          "$character"
        ];
        add_newline = true;

        username = {
          show_always = true;
          format = "[$user]($style)";
          style_user = "blue";
          style_root = "red";
        };

        directory = {
          format = "[$path]($style)[$read_only]($read_only_style)";
          style = "cyan";
          read_only_style = "red";
          read_only = " 󰌾";
          truncation_length = 3;
          truncate_to_repo = true;
        };

        git_branch = {
          format = " [$symbol](brown) [$branch]($style)";
          symbol = "";
          style = "bright-black";
        };

        git_status = {
          format = "([\\[$all_status$ahead_behind\\]]($style))";
          stashed = "[\${count}*](green)";
          modified = "[\${count}+](yellow)";
          deleted = "[\${count}-](red)";
          conflicted = "[\${count}~](red)";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          untracked = "[\${count}?](blue)";
          staged = "[\${count}+](green)";
        };

        jobs = {
          format = " [$symbol]($style)";
          symbol = "●";
          style = "purple";
          number_threshold = 1;
        };

        character = {
          format = "$symbol ";
          success_symbol = " [λ](purple)";
          error_symbol = " [λ](red)";
        };
      };
    };
  };
}
