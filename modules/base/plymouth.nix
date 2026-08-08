{
  flake.modules.nixos.base = {...}: {
    boot.plymouth.enable = true;
    boot.consoleLogLevel = 3;
    boot.kernelParams = ["quiet" "splash"];
    boot.initrd.verbose = false;
  };
}
