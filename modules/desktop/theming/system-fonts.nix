{
  flake.modules.nixos.theming_system-fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      corefonts
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      unifont
    ];
  };
}
