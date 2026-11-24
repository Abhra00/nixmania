{
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.epsonscan2];
    };
  };
}
