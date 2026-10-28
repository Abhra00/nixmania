{
  flake.modules.nixos.feature_nix-ld = {
    programs.nix-ld = {
      enable = true;
    };
  };
}
