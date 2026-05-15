{
  flake.modules.nixos.theming_stylix = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = let
        colors = import ./_colors.nix;
      in
        colors.palette;
      image = config.lib.stylix.pixel "base00";
    };
  };
}
