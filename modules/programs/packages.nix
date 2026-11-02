{
  flake.modules.nixos.cli_packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      # Disk & filesystem
      dysk
      gdu

      # Media
      chafa
      ffmpeg
      ffmpegthumbnailer
      imagemagick
      kew

      # Documents
      ghostscript
      typst

      # Utilities
      bc
      hyperfine
      jq
    ];
  };

  flake.modules.nixos.gui_packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      file-roller
      eog
    ];
  };
}
