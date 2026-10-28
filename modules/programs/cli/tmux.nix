{
  flake.modules.nixos.cli_tmux = {
    hm.programs.tmux = {
      enable = true;

      # Core
      baseIndex = 1;
      shortcut = "t";
      keyMode = "vi";
      focusEvents = true;
      historyLimit = 100000;
      terminal = "tmux-256color";

      # Mouse and navigation
      mouse = true;
      customPaneNavigationAndResize = true;

      extraConfig = ''
        # Terminal
        set -as terminal-features ",xterm*:RGB"
        set -as terminal-features ",xterm*:usstyle"

        # Behavior
        set -s set-clipboard on
        set -g repeat-time 0
        set -g allow-passthrough on
        set -g renumber-windows on
        set -g set-titles on
        set -g set-titles-string "#T"
        set -g monitor-activity on
        set -g monitor-bell on
        setw -g window-status-bell-style "default"

        # Statusline
        set -g status-justify "centre"
        set -g status-interval 5
        set -g status-left-length 100
        set -g status-right-length 100

        # Popup border
        set -g popup-border-lines rounded

        # Keys
        bind e confirm-before -p "kill other panes? (y/n)" "kill-pane -a"
        bind o display-popup -E -w 90% -h 90% -d '#{pane_current_path}' yazi
        bind g display-popup -E -w 90% -h 90% -d '#{pane_current_path}' lazygit

        bind -n C-S-Left swap-window -t -1 \; previous-window
        bind -n C-S-Right swap-window -t +1 \; next-window

        bind | split-window -h -c "#{pane_current_path}" \; select-layout even-horizontal
        bind % split-window -h -c "#{pane_current_path}" \; select-layout even-horizontal
        bind - split-window -v -c "#{pane_current_path}" \; select-layout even-vertical
        bind '"' split-window -v -c "#{pane_current_path}" \; select-layout even-vertical
      '';
    };
  };
}
