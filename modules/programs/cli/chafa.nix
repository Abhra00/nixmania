{
  flake.modules.nixos.cli_chafa = {pkgs, ...}: {
    hm.home.packages = [pkgs.chafa];
  };
}
