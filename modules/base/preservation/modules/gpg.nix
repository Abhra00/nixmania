{
  flake.modules.nixos.service_gpg = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];
  };
}
