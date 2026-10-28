{
  flake.modules.nixos.theming_defaults = {
    hm.home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
