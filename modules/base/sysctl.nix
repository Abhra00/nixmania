{
  flake.modules.nixos.base = {
    boot.kernel.sysctl = {
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
    };
  };
}
