{
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # CLI & TUI
      kew
      terminal-toys
      wget
      curl
      yt-dlp
      nvme-cli
      smartmontools

      # GUI
      eog
      onlyoffice-desktopeditors

      # Devenv
      devenv
    ];
  };
}
