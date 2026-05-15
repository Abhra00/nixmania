{
  flake.modules.nixos.login-manager_gdm = {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
