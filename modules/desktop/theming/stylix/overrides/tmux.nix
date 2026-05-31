{
  flake.modules.nixos.cli_tmux = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    c = config.lib.stylix.colors;
  in {
    hm.programs.tmux.extraConfig = lib.mkIf cfg ''
      # Theme
      set -g pane-border-lines simple
      set -g status-style "bg=default,fg=default"
      set -g status-left "#[fg=#${c.base00},bg=#${c.base0D},bold] #S #[bg=default] "
      set -g status-right "#[fg=#${c.base0E}]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#[fg=#${c.base0E}] #[fg=#${c.base03}]#h"
      set -g window-status-format "#[fg=#${c.base03}] #I:#W "
      set -g window-status-current-format "#[fg=#${c.base0E},bold] #I:#W "
      set -g pane-border-style "fg=#${c.base03}"
      set -g pane-active-border-style "fg=#${c.base0D}"
      set -g message-style "bg=default,fg=#${c.base0D}"
      set -g message-command-style "bg=default,fg=#${c.base0D}"
      set -g mode-style "bg=#${c.base0D},fg=#${c.base00}"
      setw -g clock-mode-colour "#${c.base0D}"
    '';
  };
}
