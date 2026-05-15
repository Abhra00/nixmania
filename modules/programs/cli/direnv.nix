{
  flake.modules.nixos.cli_direnv = {
    hm.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
