{
  flake.modules.nixos.service_ssh.persist.user.directories = [
    {
      directory = ".ssh";
      mode = "0700";
    }
  ];
}
