{
  config,
  inputs,
  ...
}: let
  args = {inherit inputs username confDir;};
  username = "bugs";
  confDir = "/home/${username}/nixmania";

  mkSystem = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = args;
      modules = [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        config.flake.modules.nixos.${hostname}
        {networking.hostName = hostname;}
        inputs.home-manager.nixosModules.home-manager
        {home-manager.extraSpecialArgs = args;}
      ];
    };
in {
  flake.nixosConfigurations = {
    TR-100-machine = mkSystem "TR-100-machine";
  };
}
