{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$jobs"
          "$username"
          "$hostname"
          "$nix_shell"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$character"
        ];
        add_newline = true;
        continuation_prompt = "[∙  ┆ ](bright-black)";
        directory = {
          truncation_symbol = "…/";
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✘](bold red)";
        };
        git_branch = {
          format = "on [$symbol$branch(:$remote_branch)]($style)";
          symbol = "";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](bold purple) ($ahead_behind$stashed)]($style)";
          style = "bold cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          diverged = "​";
          stashed = "≡";
          ahead = "⇡\${count} ";
          behind = "⇣\${count} ";
        };
        cmd_duration = {
          format = "took [$duration]($style) ";
        };
        jobs = {
          format = "[$symbol]($style) ";
          symbol = "✦";
          style = "blue";
          number_threshold = 1;
        };
        nix_shell = {
          format = "[$symbol]($style)[nsh](bold orange) [│](bright-black) [$name](bold blue) [│](bright-black) ";
          symbol = "󱄅 ";
          style = "blue";
          impure_msg = "";
          pure_msg = "";
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bols purple";
          detect_extensions = [];
          detect_files = [];
        };
      };
    };
  };
}
