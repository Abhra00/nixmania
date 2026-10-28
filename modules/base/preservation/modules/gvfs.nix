{
  flake.modules.nixos.service_gvfs = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      ".local/share/Trash"
    ];
  };
}
