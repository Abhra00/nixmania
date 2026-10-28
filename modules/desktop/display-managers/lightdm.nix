{
  flake.modules.nixos.display-manager_lightdm = {username, ...}: {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
    };

    services.displayManager = {
      defaultSession = "xfce";
      autoLogin = {
        enable = true;
        user = username;
      };
    };
  };
}
