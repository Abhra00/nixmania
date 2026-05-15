{
  flake.modules.nixos.theming_defaults = {pkgs, ...}: {
    hm = {
      gtk.gtk4.theme = null;
      home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 22;
        gtk.enable = true;
        x11.enable = true;
      };

      gtk.iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
