{
  flake.modules.nixos.rule_igpu = {
    services.udev.extraRules = ''
      KERNEL=="card*", KERNELS=="0000:05:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
    '';
  };
}
