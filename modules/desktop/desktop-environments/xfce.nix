{
  flake.modules.nixos.desktop-environment_xfce = {
    services.xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
    };
  };
}
