{
  flake.modules.nixos.display-manager_lightdm.persist.directories = [
    {
      directory = "/var/lib/lightdm";
      group = "lightdm";
      mode = "1770";
      user = "lightdm";
    }
    {
      directory = "/var/lib/lightdm-data";
      group = "lightdm";
      mode = "1775";
      user = "lightdm";
    }
    "/var/lib/AccountsService"
  ];
}
