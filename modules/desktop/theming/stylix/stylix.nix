{
  flake.modules.nixos.theming_stylix = {
    inputs,
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme =
        (import ./_palette.nix {
          self = inputs.self;
          inherit lib;
        }).Palette;
      image = "${inputs.self}/assets/pictures/Wallpapers/Wallpaper.png";

      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 22;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus";
      };

      opacity = {
        applications = 1.0;
        desktop = 1.0;
        popups = 1.0;
        terminal = 1.0;
      };
    };
  };
}
