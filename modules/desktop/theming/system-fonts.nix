{
  flake.modules.nixos.theming_system-fonts = {
    inputs,
    pkgs,
    ...
  }: let
    regular = with pkgs; [
      corefonts
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      unifont
      inputs.plemoljp-symbols.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    nerd-fonts = with pkgs.nerd-fonts; [
      symbols-only
    ];
  in {
    fonts.packages = regular ++ nerd-fonts;
  };
}
