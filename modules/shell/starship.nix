{
  flake.modules.nixos.shell_starship = {lib, ...}: {
    hm.programs.starship = {
      enable = true;

      settings = {
        format = lib.concatStrings [
          # Left
          ''[\$](bold purple)''
          "$directory"
          "$git_branch"
          "$git_status"
          "$git_state"

          # Right
          "$fill"
          "$nix_shell"
          "$cmd_duration"
          "$time"

          # 2nd line
          "$line_break"
          "$character"
        ];

        add_newline = true;

        # Directory
        directory = {
          format = " [·](dimmed) [$path]($style)[$read_only]($read_only_style) ";
          style = "bold cyan";
          truncation_length = 1;
          truncation_symbol = "…/";
        };

        # Git
        git_branch = {
          format = "[·](dimmed) [$branch(:$remote_branch)]($style) ";
          style = "bold purple";
        };
        git_status = {
          deleted = "x";
          format = ''([$all_status$ahead_behind]($style) )'';
          style = "bold red";
        };
        git_state = {
          am = "am";
          am_or_rebase = "am/rebase";
          bisect = "bisecting";
          cherry_pick = "cherry-picking";
          format = "[·](dimmed) [$state( $progress_current/$progress_total)]($style)";
          merge = "merging";
          rebase = "rebasing";
          revert = "reverting";
          style = "bold yellow";
        };

        # Fill
        fill = {
          style = "bright-black dimmed";
          symbol = "─";
        };

        # Nix shell
        nix_shell = {
          format = " [$symbol]($style) [·](dimmed)";
          symbol = "󱄅";
        };

        # Duration
        cmd_duration = {
          format = " [$duration]($style) [·](dimmed)";
          min_time = 5000;
          style = "bold white dimmed";
        };

        # Time
        time = {
          disabled = false;
          format = " [$time]($style)";
          style = "bold white dimmed";
          time_format = "%R";
        };

        # Prompt
        character = {
          error_symbol = ''[[└](bright-black dimmed) ❯](bold red)'';
          success_symbol = ''[[└](bright-black dimmed) ❯](bold green)'';
        };
        continuation_prompt = "[·](dimmed)";
      };

      presets = ["nerd-font-symbols"];
    };
  };
}
