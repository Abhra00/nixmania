{
  flake.modules.nixos.cli_tmux = {
    config,
    pkgs,
    ...
  }: let
    tmux-ide = pkgs.writeShellApplication {
      name = "tmux-ide";
      runtimeInputs = [config.hm.programs.tmux.package];
      text = ''
        tmux select-pane -L
        tmux split-window -v -l 20%
        tmux split-window -h -l 66%
        tmux split-window -h -l 50%
      '';
    };
  in {
    hm.home.packages = [tmux-ide];
  };
}
