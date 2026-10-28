{
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # CLI & TUI
      kew
      wget
      curl
      yt-dlp
      nvme-cli
      smartmontools

      # GUI
      onlyoffice-desktopeditors
    ];
  };
}
