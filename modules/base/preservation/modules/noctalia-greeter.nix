{
  flake.modules.nixos.display-manager_noctalia-greeter.persist.directories = [
    {
      directory = "/var/lib/noctalia-greeter";
      group = "greeter";
      mode = "0750";
      user = "greeter";
    }
    "/var/lib/AccountsService"
  ];
}
