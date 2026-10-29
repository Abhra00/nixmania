{
  flake.modules.nixos.display-manager_noctalia-greeter = {
    config,
    lib,
    ...
  }: let
    cursor = config.stylix.cursor;
  in {
    services.displayManager.noctalia-greeter.settings.cursor = lib.mkIf ((config.stylix.enable or false) && cursor != null) {
      theme = cursor.name;
      size = cursor.size;
      path = "${cursor.package}/share/icons";
    };
  };
}
