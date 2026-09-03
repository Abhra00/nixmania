{
  flake.modules.nixos.service_gnome-keyring = {
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
