{
  flake.modules.nixos.TR-100-machine = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # CLI & TUI
      kew
      terminal-toys
      wget
      curl
      yt-dlp

      # GUI
      eog
      onlyoffice-desktopeditors
      satty

      # Rust
      rustlings
      rustup

      # Gcc
      gcc

      # Python
      python3

      # Nodejs
      nodejs
    ];
  };
}
