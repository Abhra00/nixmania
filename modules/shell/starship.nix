{
  flake.modules.nixos.shell_starship = {
    hm.programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 200;
        format = "$nix_shell$directory$git_branch$git_status$cmd_duration\n$character";

        character = {
          success_symbol = "[➜](green)";
          error_symbol = "[✘](red)";
        };

        directory = {
          truncation_length = 2;
          truncation_symbol = "…/";
          home_symbol = "~";
          style = "blue";
          repo_root_style = "blue";
          repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          ahead = "⇡ ";
          behind = "⇣ ";
          stashed = "≡ ";
        };
        nix_shell = {
          format = "[$symbol]($style)[$state](red) [│](bright-black) ";
          symbol = "󱄅 ";
          style = "orange";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
      };
    };
  };
}
