{
  flake.modules.nixos.service_gnome-keyring = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
