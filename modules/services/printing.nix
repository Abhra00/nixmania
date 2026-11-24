{
  flake.modules.nixos.service_printing = {pkgs, ...}: {
    services.printing.enable = true;
    services.printing.drivers = [pkgs.epson-escpr];
  };
}
