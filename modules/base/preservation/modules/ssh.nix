{
  flake.modules.nixos.service_ssh = {username, ...}: {
    preservation.preserveAt."/persistent".users.${username}.directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}
