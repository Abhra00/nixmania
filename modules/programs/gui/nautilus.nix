{
  flake.modules.nixos.gui_nautilus = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      nautilus
      glib
    ];
    hm.services.gnome-keyring.enable = true;
  };
}
