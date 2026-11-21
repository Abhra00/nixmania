{
  flake.modules.nixos.base = {...}: {
    nix.settings = {
      auto-optimise-store = true;
      build-dir = "/nix/var/nix/builds";
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      trusted-users = ["root" "@wheel"];
    };
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
    nix.channel.enable = false;
  };
}
