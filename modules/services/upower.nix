{
  flake.modules.nixos.service_upower = {
    services.upower.enable = true;
  };
}
