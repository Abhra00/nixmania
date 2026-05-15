{
  flake.modules.nixos.service_postgresql = {pkgs, ...}: {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
    };
  };
}
