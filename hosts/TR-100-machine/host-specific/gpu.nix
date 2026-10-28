{
  flake.modules.nixos.TR-100-machine = {config, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = false;
    };

    hardware.amdgpu.initrd.enable = true;

    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
    };

    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
