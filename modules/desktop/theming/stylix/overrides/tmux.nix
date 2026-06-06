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

      # Left: session name pill
      set -g status-left "#{?client_prefix,#[fg=#${c.base0B}],#[fg=#${c.base0E}]}#[bg=default]#{?client_prefix,#[bg=#${c.base0B}],#[bg=#${c.base0E}]}#[fg=#${c.base00}] #[bg=#${c.base02},fg=#${c.base05}] #S#[fg=#${c.base02},bg=default] "
      set -g status-left-length 40

      # Right: date pill
      set -g status-right "#[fg=#${c.base0F},bg=default]#[fg=#${c.base00},bg=#${c.base0F}]󰃰 #[bg=#${c.base02},fg=#${c.base05}] %Y-%m-%d %H:%M#[fg=#${c.base02},bg=default]"
      set -g status-right-length 40

      # Windows
      set -g window-status-format "#[fg=#${c.base02},bg=default]#[bg=#${c.base02},fg=#${c.base05}]#I:#W#[fg=#${c.base02},bg=default] "
      set -g window-status-current-format "#[fg=#${c.base0D},bg=default]#[bg=#${c.base0D},fg=#${c.base00}]#I #[bg=#${c.base02},fg=#${c.base05}] #W#[fg=#${c.base02},bg=default] "
      set -g window-status-separator ""

      # Pane borders
      set -g pane-border-style "fg=#${c.base02}"
      set -g pane-active-border-style "fg=#${c.base0D}"

      # Messages / copy mode
      set -g message-style "bg=#${c.base02},fg=#${c.base0D}"
      set -g message-command-style "bg=#${c.base02},fg=#${c.base0D}"
      set -g mode-style "bg=#${c.base0D},fg=#${c.base00}"
      setw -g clock-mode-colour "#${c.base0D}"
    '';
  };
}
