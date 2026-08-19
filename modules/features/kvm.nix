{
  flake.modules.nixos.feature_kvm = {
    pkgs,
    username,
    ...
  }: {
    virtualisation = {
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          vhostUserPackages = [pkgs.virtiofsd];
        };
      };
    };

    users.groups.libvirtd.members = [username];
    users.groups.kvm.members = [username];

    programs.virt-manager.enable = true;
  };
}
