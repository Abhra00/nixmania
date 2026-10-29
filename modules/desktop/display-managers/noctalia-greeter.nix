{
  flake.modules.nixos.display-manager_noctalia-greeter = {
    config,
    lib,
    inputs,
    username,
    ...
  }: let
    cursor = config.stylix.cursor;
  in {
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordless-sync-users = [username];
      settings = {
        appearance.password_style = "random";
        clock = {
          enable = true;
          position = "bottom-right";
        };
        keyboard = {
          layout = "us";
        };
        cursor = lib.mkIf ((config.stylix.enable or false) && cursor != null) {
          theme = cursor.name;
          size = cursor.size;
          path = "${cursor.package}/share/icons";
        };
      };
    };
  };
}
