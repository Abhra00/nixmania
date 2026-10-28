{
  flake.modules.nixos.feature_kvm = {
    preservation.preserveAt."/persistent".directories = [
      "/var/lib/libvirt"
    ];
  };
}
