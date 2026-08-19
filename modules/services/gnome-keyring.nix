{
  flake.modules.nixos.service_gnome-keyring = {
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
