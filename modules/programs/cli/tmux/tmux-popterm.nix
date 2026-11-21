{
  flake.modules.nixos.cli_tmux = {
    config,
    pkgs,
    ...
  }: let
    popup-term = pkgs.writeShellApplication {
      name = "tmux-popup-term";
      runtimeInputs = [config.hm.programs.tmux.package];
      text = ''
        if ! tmux has-session -t "=popup" 2>/dev/null; then
          tmux new-session -d -s popup
          tmux set-option -t popup status off
        fi
        exec tmux attach-session -t "=popup"
      '';
    };
  in {
    hm.home.packages = [popup-term];
  };
}
