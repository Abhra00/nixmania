{
  flake.modules.nixos.cli_yazi = {
    hm.programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
  };
}
