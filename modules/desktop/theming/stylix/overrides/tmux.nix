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
      set -g status-style "bg=#${c.base00},fg=#${c.base05}"
      set -g status-left "#[fg=#${c.base00},bg=#${c.base0D},bold] #S #[fg=#${c.base05},bg=#${c.base00}] "
      set -g status-right "#[fg=#${c.base0D}]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#[fg=#${c.base04}]#h "
      set -g window-status-format "#[fg=#${c.base04}] #I:#W "
      set -g window-status-current-format "#[fg=#${c.base0D},bold] #I:#W "
      set -g pane-border-style "fg=#${c.base02}"
      set -g pane-active-border-style "fg=#${c.base0D}"
      set -g message-style "bg=#${c.base01},fg=#${c.base0D}"
      set -g message-command-style "bg=#${c.base01},fg=#${c.base0D}"
      set -g mode-style "bg=#${c.base0D},fg=#${c.base00}"
      setw -g clock-mode-colour "#${c.base0D}"
    '';
  };
}
