{
  flake.modules.nixos.service_gpg.persist.user.directories = [
    {
      directory = ".gnupg";
      mode = "0700";
    }
  ];
}
