{
  flake.modules.nixos.base = {
    systemd.coredump.settings.Coredump.MaxUse = "200M";
  };
}
