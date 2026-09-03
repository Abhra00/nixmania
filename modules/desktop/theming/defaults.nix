{
  flake.modules.nixos.theming_defaults = {pkgs, ...}: {
    hm = {
      home.pointerCursor = {
        enable = true;
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
