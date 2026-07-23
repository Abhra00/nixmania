{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 200;
        format = "[$nix_shell$directory$git_branch$git_status]($style)$character";

        character = {
          error_symbol = "[❯](bold red)";
          success_symbol = "[❯](bold green)";
        };

        directory = {
          truncation_length = 2;
          truncation_symbol = "…/";
          style = "bold blue";
          repo_root_style = "bold cyan";
          repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        };

        git_branch = {
          format = "[$branch]($style) ";
          style = "italic purple";
        };

        git_status = {
          format = "[$all_status$ahead_behind]($style)";
          style = "cyan";
          ahead = "⇡$count ";
          diverged = "⇕⇡$ahead_count⇣$behind_count ";
          behind = "⇣$count ";
          conflicted = " ";
          up_to_date = " ";
          untracked = "? ";
          modified = " ";
          staged = "";
          renamed = "";
          deleted = "";
        };
        nix_shell = {
          format = "[$symbol]($style)[$state](bold red) [│](bold bright-black) ";
          symbol = "󱄅 ";
          style = "bold orange";
        };
      };
    };
  };
}
