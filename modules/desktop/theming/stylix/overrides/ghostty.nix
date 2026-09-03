{
  flake.modules.nixos.gui_ghostty = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors;
    hex = config.lib.stylix.colors.withHashtag;
    opacity = config.stylix.opacity.terminal;
    fonts = config.stylix.fonts;
  in {
    hm.programs.ghostty.settings = lib.mkIf cfg {
      font-family = fonts.monospace.name;
      font-family-italic = "Cartograph CF Italic";
      font-family-bold-italic = "Cartograph CF Italic";
      font-size = fonts.sizes.terminal;

      background = stx.base00;
      foreground = stx.base05;
      background-opacity = opacity;

      cursor-color = stx.base05;
      cursor-text = stx.base00;

      selection-background = stx.base02;
      selection-foreground = stx.base05;

      split-divider-color = stx.base03;

      search-background = stx.base0A;
      search-foreground = stx.base00;
      search-selected-background = stx.base09;
      search-selected-foreground = stx.base00;

      palette = [
        "0=${hex.base03}"
        "1=${hex.base08}"
        "2=${hex.base0B}"
        "3=${hex.base0A}"
        "4=${hex.base0D}"
        "5=${hex.base0E}"
        "6=${hex.base0C}"
        "7=${hex.base05}"
        "8=${hex.base03}"
        "9=${hex.base08}"
        "10=${hex.base0B}"
        "11=${hex.base0A}"
        "12=${hex.base0D}"
        "13=${hex.base0E}"
        "14=${hex.base0C}"
        "15=${hex.base05}"
      ];
    };
  };
}
