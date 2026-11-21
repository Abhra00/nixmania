{
  flake.modules.nixos.service_fwupd = {
    services.fwupd.enable = true;
  };
}
