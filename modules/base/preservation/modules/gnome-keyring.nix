{
  flake.modules.nixos.service_gnome-keyring = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
