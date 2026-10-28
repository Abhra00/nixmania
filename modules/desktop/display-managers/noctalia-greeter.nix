{
  flake.modules.nixos.display-manager_noctalia-greeter = {
    pkgs,
    inputs,
    username,
    ...
  }: {
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
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
        };
      };
    };
  };
}
