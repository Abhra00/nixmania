{
  flake.modules.nixos.VM-100-machine = {
    storage.zfs = {
      device = "/dev/vda";
      hostId = "650a0285";
      arcMaxGiB = 1;
    };
  };
}
