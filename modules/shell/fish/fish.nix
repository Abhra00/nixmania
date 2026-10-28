{
  flake.modules.nixos.shell_fish = {inputs, ...}: {
    imports = [../_common.nix];

    programs.fish.enable = true;

    hm.programs.fish = {
      enable = true;
      generateCompletions = true;

      plugins = [
        {
          name = "tide";
          src = inputs.tide;
        }
      ];

      interactiveShellInit = ''
        # Suppress the greetings
        set -g fish_greeting

        # Pwd directory length
        set -g fish_prompt_pwd_dir_length 1

        # Enable vi mode
        fish_vi_key_bindings

        # Set every mode cursors to block with blinking cursor
        set -g fish_cursor_default block blink
        set -g fish_cursor_insert block blink
        set -g fish_cursor_replace block blink
        set -g fish_cursor_replace_one block blink
        set -g fish_cursor_visual block blink
        set -g fish_cursor_external block blink

        # Enable transient prompt
        set -g fish_transient_prompt 1

        # Preload fzf-module
        functions -q fzf-module

        # fzf-module keybindings
        for mode in insert default
            bind -M $mode \e\cf fzf_file_widget        # Ctrl+Alt+F — file search
            bind -M $mode \e\cp fzf_process_widget     # Ctrl+Alt+P — process
            bind -M $mode \e\cl fzf_git_log_widget     # Ctrl+Alt+L — git log
            bind -M $mode \e\cs fzf_git_status_widget  # Ctrl+Alt+S — git status
            bind -M $mode \e\cr fzf_history_widget     # Ctrl+Alt+R — history
            bind -M $mode \e\cv fzf_variable_widget    # Ctrl+Alt+V — variables
        end
      '';
    };
  };
}
