{
  flake.modules.nixos.vm_guest = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/profiles/qemu-guest.nix")];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    boot.initrd.availableKernelModules = ["virtio_pci" "virtio_blk" "virtio_scsi" "xhci_pci" "ahci" "sd_mod" "sr_mod"];

    # virtio disks have no by-id serials, so find the pool by partition label.
    boot.zfs.devNodes = "/dev/disk/by-partlabel";

    boot.kernelParams = ["video=Virtual-1:1920x1080"];

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
