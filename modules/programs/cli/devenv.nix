{
  flake.modules.nixos.cli_devenv = {
    hm.programs.devenv = {
      enable = true;
    };
  };
}
