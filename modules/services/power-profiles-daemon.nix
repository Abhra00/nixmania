{
  flake.modules.nixos.service_power-profiles-daemon = {
    services.power-profiles-daemon.enable = true;
  };
}
