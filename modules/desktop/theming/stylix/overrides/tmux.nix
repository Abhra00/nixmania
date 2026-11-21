{
  flake.modules.nixos.cli_tmux = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    colors = config.lib.stylix.extended-palette.colors;

    sepL = builtins.fromJSON ''"\ue0b6"'';
    sepR = builtins.fromJSON ''"\ue0b4"'';

    # Never underline or italicize anything
    plain = "nounderscore,noitalics";

    # Statusline background
    barBg = colors.base03;

    # Bell-aware accents
    inactiveAccent = "#{?window_bell_flag,${colors.magenta},${colors.yellow}}";
    inactiveNumFg = "#{?window_bell_flag,${colors.base2},${colors.bg}}";
    inactiveNumWeight = "#{?window_bell_flag,bold,nobold}";
    currentAccent = "#{?window_bell_flag,${colors.magenta},${colors.blue}}";
  in {
    hm.programs.tmux.extraConfig = lib.mkIf cfg ''
      # General theming
      set -g window-style "fg=default,bg=default,${plain}"
      set -g window-active-style "fg=default,bg=default,${plain}"

      # Pane number display
      set-option -g display-panes-active-colour "${colors.blue}"
      set-option -g display-panes-colour "${colors.orange}"

      # Popup (display-popup)
      set-option -g popup-style "bg=default,${plain}"
      set-option -g popup-border-style "fg=${colors.magenta},bg=default,${plain}"

      # Clock
      set-window-option -g clock-mode-colour "${colors.green}"

      # Mode & command prompt styling
      set -g mode-style "fg=${colors.base2},bg=${colors.base02},${plain}"
      set -g message-style "fg=${colors.base2},bg=${colors.base02},fill=${barBg},${plain}"
      set -g message-command-style "fg=${colors.base2},bg=${colors.base02},fill=${barBg},${plain}"

      # Pane border
      set -g pane-border-style "fg=${colors.base02},${plain}"
      set -g pane-active-border-style "fg=${colors.base2},${plain}"

      # Statusline
      set -g status-style "fg=${colors.base01},bg=${barBg},${plain}"
      set -g status-left-style "NONE,${plain}"
      set -g status-right-style "NONE,${plain}"

      set -g status-left "#[fg=${colors.base02},bg=${colors.base2},bold,${plain}] #S:#I.#P #[fg=${colors.bg},bg=${colors.base1},bold,${plain}] #(whoami) #[fg=${colors.base1},bg=${barBg},${plain}]${sepR}"
      set -g status-right "#[fg=${colors.base1},bg=${barBg},nobold,${plain}]${sepL}#[fg=${colors.bg},bg=${colors.base1},bold,${plain}] #h #[fg=${colors.base1},bg=${barBg},${plain}]"

      setw -g window-status-separator " "
      setw -g window-status-activity-style "fg=${colors.fg},bg=${barBg},${plain}"
      setw -g window-status-style "NONE,fg=${colors.fg},bg=${barBg},${plain}"
      setw -g window-status-current-style "NONE,fg=${colors.fg},bg=${barBg},${plain}"

      setw -g window-status-format '#[fg=${inactiveAccent},bg=${barBg},${plain}]${sepL}#[fg=${inactiveNumFg},bg=${inactiveAccent},${inactiveNumWeight},${plain}]#I #[fg=${colors.bg},bg=${colors.base1},${plain}] #{b:pane_current_path} #[fg=${colors.base1},bg=${barBg},${plain}]${sepR}'
      setw -g window-status-current-format '#[fg=${currentAccent},bg=${barBg},${plain}]${sepL}#[fg=${colors.base2},bg=${currentAccent},bold,${plain}]#I #[fg=${colors.bg},bg=${colors.base2},bold,${plain}] #{b:pane_current_path} #[fg=${colors.base2},bg=${barBg},${plain}]${sepR}'
    '';
  };
}
