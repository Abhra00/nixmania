{
  flake.modules.nixos.base = {...}: {
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
      trusted-users = ["root" "@wheel"];
    };
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    nixpkgs.config.allowUnfree = true;
    documentation.nixos.enable = false;
    nix.channel.enable = false;
  };
}
