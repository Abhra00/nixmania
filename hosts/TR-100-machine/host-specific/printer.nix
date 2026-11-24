{
  flake.modules.nixos.TR-100-machine = {
    config,
    lib,
    ...
  }: {
    hardware.printers = lib.mkIf config.services.printing.enable {
      ensurePrinters = [
        {
          name = "Epson_L3110";
          deviceUri = "usb://EPSON/L3110%20Series";
          model = "epson-inkjet-printer-escpr/Epson-L3110_Series-epson-escpr-en.ppd";
          ppdOptions.PageSize = "A4";
        }
      ];
      ensureDefaultPrinter = "Epson_L3110";
    };
  };
}
