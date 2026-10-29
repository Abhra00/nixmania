{
  flake.modules.nixos.base = {
    services.journald.settings.Journal.SystemMaxUse = "500M";
  };
}
