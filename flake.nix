{
  description = "NIXMANIA";
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {formatter = pkgs.alejandra;};
      imports = [
        (inputs.import-tree ./hosts)
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
      ];
    };

  inputs = {
    # disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox addons (rycee)
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # import-tree
    import-tree.url = "github:vic/import-tree";

    # nix index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # noctalia
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia greeter
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # plemoljp symbols
    plemoljp-symbols = {
      url = "github:Abhra00/PlemolJP-Symbols";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # preservation
    preservation.url = "github:nix-community/preservation";

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tide
    tide = {
      url = "github:plttn/tide";
      flake = false;
    };
  };
}
