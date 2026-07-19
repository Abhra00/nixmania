{
  flake.modules.nixos.gui_ghostty = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors;
    fonts = config.stylix.fonts;
    opacity = config.stylix.opacity.terminal;

    math = import ../../../../../lib/math.nix {inherit lib;};
    hsluv = import ../../../../../lib/hsluv.nix {inherit lib math;};
    base0E_20 = hsluv.mixRGB stx.base00 stx.base0E 0.20;
  in {
    hm.programs.ghostty.settings = lib.mkIf cfg {
      font-family = "${fonts.monospace.name} Med";
      font-family-bold = fonts.monospace.name;
      font-family-italic = "Cartograph CF";
      font-family-bold-italic = "Cartograph CF";
      font-size = fonts.sizes.terminal;

      background-opacity = opacity;

      foreground = stx.base05;
      background = stx.base00;

      cursor-color = stx.base06;
      cursor-text = stx.base00;

      selection-foreground = stx.base0E;
      selection-background = base0E_20;

      search-background = stx.base0E;
      search-foreground = stx.base00;
      search-selected-background = base0E_20;
      search-selected-foreground = stx.base0E;

      palette = [
        "0=#${stx.base02}"
        "1=#${stx.base08}"
        "2=#${stx.base0B}"
        "3=#${stx.base0A}"
        "4=#${stx.base0D}"
        "5=#${stx.base0E}"
        "6=#${stx.base0C}"
        "7=#${stx.base05}"
        "8=#${stx.base02}"
        "9=#${stx.base08}"
        "10=#${stx.base0B}"
        "11=#${stx.base0A}"
        "12=#${stx.base0D}"
        "13=#${stx.base0E}"
        "14=#${stx.base0C}"
        "15=#${stx.base05}"
      ];
    };
  };
}
