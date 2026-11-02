{
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # CLI & TUI
      wget
      curl
      nvme-cli
      smartmontools
    ];
  };
}
