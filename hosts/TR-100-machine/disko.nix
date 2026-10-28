{
  flake.modules.nixos.TR-100-machine = {
    storage.zfs = {
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HBLU-00BL2_S65DNX1T336294";
      dataDevice = "/dev/disk/by-id/ata-CT500BX500SSD1_2312E6BE94E7";
      hostId = "f92ca384";
      arcMaxGiB = 4;
    };
  };
}
