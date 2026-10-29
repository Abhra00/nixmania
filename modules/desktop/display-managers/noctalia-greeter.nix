{
  flake.modules.nixos.display-manager_noctalia-greeter = {
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
        keyboard = {
          layout = "us";
        };
      };
    };
  };
}
