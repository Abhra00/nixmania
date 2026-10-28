{
  flake.modules.nixos.service_bluetooth = {
    preservation.preserveAt."/persistent".directories = [
      "/var/lib/bluetooth"
    ];
  };
}
