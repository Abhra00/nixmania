{
  flake.modules.nixos.theming_system-fonts = {
    inputs,
    pkgs,
    ...
  }: let
    plemoljp-symbols = inputs.plemoljp-console-symbols.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    fonts.packages = with pkgs; [
      corefonts
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      plemoljp-symbols
      unifont
      nerd-fonts.symbols-only
    ];
  };
}
