{
  flake.modules.nixos.cli_tmux = {
    hm.programs.tmux = {
      enable = true;
      prefix = "C-Space";
      keyMode = "vi";
      mouse = true;
      baseIndex = 1;
      historyLimit = 50000;
      escapeTime = 0;
      focusEvents = true;
      aggressiveResize = true;
      terminal = "tmux-256color";
      sensibleOnTop = false;
      extraConfig = ''
        # Secondary prefix
        set -g prefix2 C-b
        bind C-Space send-prefix
        # Vi copy mode
        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send -X copy-selection-and-cancel
        # Pane controls
        bind -n M-Enter split-window -v -c "#{pane_current_path}"
        bind -n M-S-Enter split-window -h -c "#{pane_current_path}"
        bind -n M-Escape kill-pane
        bind h split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind x kill-pane
        bind -n C-M-Left select-pane -L
        bind -n C-M-Right select-pane -R
        bind -n C-M-Up select-pane -U
        bind -n C-M-Down select-pane -D
        bind -n C-M-S-Left resize-pane -L 5
        bind -n C-M-S-Down resize-pane -D 5
        bind -n C-M-S-Up resize-pane -U 5
        bind -n C-M-S-Right resize-pane -R 5
        # Window navigation
        bind r command-prompt -I "#W" "rename-window -- '%%'"
        bind c new-window -c "#{pane_current_path}"
        bind k kill-window
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9
        bind -n M-Left select-window -t -1
        bind -n M-Right select-window -t +1
        bind -n M-S-Left swap-window -t -1 \; select-window -t -1
        bind -n M-S-Right swap-window -t +1 \; select-window -t +1
        # Session controls
        bind R command-prompt -I "#S" "rename-session -- '%%'"
        bind C new-session -c "#{pane_current_path}"
        bind K kill-session
        bind P switch-client -p
        bind N switch-client -n
        bind -n M-Up switch-client -p
        bind -n M-Down switch-client -n
        # Floats
        bind g display-popup -E -d '#{pane_current_path}' -w 95% -h 95% -T " lazygit" "lazygit"
        bind e display-popup -E -d '#{pane_current_path}' -w 95% -h 95% -T " bash" "bash"
        bind f display-popup -E -d '#{pane_current_path}' -w 95% -h 95% -T " superfile" "superfile"
        # General
        set -ag terminal-overrides ",*:RGB"
        set -g renumber-windows on
        set -g set-clipboard on
        set -g allow-passthrough on
        set -g detach-on-destroy off
        set -g extended-keys on
        set -g extended-keys-format csi-u
        # Status bar
        set -g status-position top
        set -g status-interval 5
        set -g status-left-length 30
        set -g status-right-length 50
        set -g window-status-separator ""
        set -gw automatic-rename on
        set -gw automatic-rename-format '#{b:pane_current_path}'
      '';
    };
  };
}
