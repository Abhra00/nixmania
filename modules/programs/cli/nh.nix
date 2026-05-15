{
  flake.modules.nixos.cli_nh = {confDir, ...}: {
    hm.programs.nh = {
      enable = true;
      flake = confDir;

      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 3";
      };
    };
  };
}
