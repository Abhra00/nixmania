{
  flake.modules.nixos.service_gnome-keyring.persist.user.directories = [
    {
      directory = ".local/share/keyrings";
      mode = "0700";
    }
  ];
}
