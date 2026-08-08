{
  flake.modules.nixos.base = {...}: {
    zramSwap.enable = true;
  };
}
