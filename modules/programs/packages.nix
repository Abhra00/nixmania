{
  flake.modules.nixos.cli_packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      bc
      dysk
      ffmpeg
      ffmpegthumbnailer
      gdu
      ghostscript
      hyperfine
      imagemagick
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
