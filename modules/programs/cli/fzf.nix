{
  flake.modules.nixos.cli_fzf = {
    hm.programs.fzf = {
      enable = true;
      defaultOptions = [
        "--layout=reverse"
        "--style=full:sharp"
        "--color=border:8"
      ];
    };
  };
}
