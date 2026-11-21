{
  flake.modules.nixos.base = {...}: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.systemd-boot.consoleMode = "max";
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 3;

    boot.consoleLogLevel = 3;
    boot.kernelParams = ["quiet" "splash"];
  };
}
