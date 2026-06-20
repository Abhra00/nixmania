{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$jobs"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$nix_shell"
          "$line_break"
          "$python"
          "$character"
        ];
        add_newline = true;
        continuation_prompt = "[∙  ┆ ](bright-black)";
        directory = {
          style = "white";
          truncate_to_repo = false;
          truncation_symbol = "…/";
        };
        username = {
          format = "[$user]($style)";
          style_user = "bright-black";
          style_root = "red";
          show_always = false;
        };
        hostname = {
          format = "[@$hostname]($style) ";
          style = "bright-black";
          ssh_only = true;
        };
        character = {
          success_symbol = "[[](blue) ](white)";
          error_symbol = "[[](red) ](white)";
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
          stashed = "≡";
        };
        git_state = {
          format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
          min_time = 5000;
        };
        jobs = {
          format = "[$symbol]($style) ";
          symbol = "✦";
          style = "blue";
          number_threshold = 1;
        };
        nix_shell = {
          format = "[$symbol$name]($style) ";
          symbol = "󱄅 ";
          style = "bright-black";
          impure_msg = "";
          pure_msg = "";
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
          detect_extensions = [];
          detect_files = [];
        };
      };
    };
  };
}
