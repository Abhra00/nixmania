{
  flake.modules.nixos.theming_extended-palette = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    math = import "${inputs.self}/lib/math.nix" {inherit lib;};
    hsl = import "${inputs.self}/lib/hsl.nix" {inherit lib math;};
    hsluv = import "${inputs.self}/lib/hsluv.nix" {inherit lib math hsl;};
    shades = import "${inputs.self}/lib/shades.nix" {inherit lib math hsl;};
    inherit (shades) shadeDiffs mkShadeSteps mkShadeRamps;

    stx = config.lib.stylix.colors.withHashtag;
    bgSteps = mkShadeSteps stx.base00 shadeDiffs.bg;
    fgSteps = mkShadeSteps stx.base05 shadeDiffs.fg;
    accentNames = {
      red = stx.base08;
      orange = stx.base09;
      yellow = stx.base0A;
      green = stx.base0B;
      cyan = stx.base0C;
      blue = stx.base0D;
      magenta = stx.base0E;
      violet = stx.base0F;
    };

    base0D_bright = hsluv.lighten stx.base0D 0.3;

    colors =
      {
        none = "NONE";
        bg = stx.base00;
        fg = stx.base05;
        base00 = bgSteps."00";
        base01 = bgSteps."01";
        base02 = bgSteps."02";
        base03 = bgSteps."03";
        base04 = bgSteps."04";
        bg_highlight = bgSteps.bg_highlight;
        base0 = fgSteps."0";
        base1 = fgSteps."1";
        base2 = fgSteps."2";
        base3 = fgSteps."3";
        base4 = fgSteps."4";
        blue_bright = "#${base0D_bright}";
      }
      // mkShadeRamps accentNames;
  in {
    config = {
      lib.stylix.extended-palette.colors = colors;

      hm.xdg.configFile."stylix/extended-palette.json".source = (pkgs.formats.json {}).generate "extended-palette.json" (
        lib.mapAttrs (_: lib.removePrefix "#") (removeAttrs colors ["none"])
        // {inherit (config.lib.stylix.colors) author scheme slug;}
      );
    };
  };
}
