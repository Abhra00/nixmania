{
  flake.modules.nixos.service_gvfs = {
    services.gvfs.enable = true;
  };
}
