{
  config,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  args = {inherit inputs username confDir;};
  username = "bugs";
  confDir = "/home/${username}/nixmania";

  mkSystem = hostname:
    lib.nixosSystem {
      specialArgs = args;
      modules = [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        config.flake.modules.nixos.base
        config.flake.modules.nixos.${hostname}
        {networking.hostName = hostname;}
        inputs.home-manager.nixosModules.home-manager
        {home-manager.extraSpecialArgs = args;}
      ];
    };

  hostNames =
    builtins.readDir ./.
    |> lib.filterAttrs (_: type: type == "directory")
    |> builtins.attrNames;
in {
  flake.nixosConfigurations = lib.genAttrs hostNames mkSystem;
}
