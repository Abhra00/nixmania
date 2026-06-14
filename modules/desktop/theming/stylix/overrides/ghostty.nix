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
  in {
    hm.programs.ghostty.settings = lib.mkIf cfg {
      font-family = fonts.monospace.name;
      font-size = fonts.sizes.terminal;

      background-opacity = opacity;

      foreground = stx.base05;
      background = stx.base00;

      cursor-color = stx.base05;
      cursor-text = stx.base00;

      selection-foreground = stx.base05;
      selection-background = stx.base02;

      search-background = stx.base0E;
      search-foreground = stx.base00;
      search-selected-background = stx.base0F;
      search-selected-foreground = stx.base00;

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
