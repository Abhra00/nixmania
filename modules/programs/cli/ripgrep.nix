{
  flake.modules.nixos.cli_ripgrep = {
    hm.programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };
  };
}
