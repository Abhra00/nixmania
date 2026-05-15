{
  flake.modules.nixos.gui_foot = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors;
    fonts = config.stylix.fonts;
    polarity = config.stylix.polarity;
    opacity = config.stylix.opacity.terminal;
    colorTheme =
      if polarity == "either"
      then "light"
      else polarity;
  in {
    hm.programs.foot.settings = lib.mkIf cfg {
      main = {
        font = "${fonts.monospace.name}:size=${toString fonts.sizes.terminal}";
        "dpi-aware" = "yes";
      };

      "colors-${colorTheme}" = {
        alpha = opacity;
        foreground = stx.base05;
        background = stx.base00;
        cursor = "${stx.base00} ${stx.base05}";
        regular0 = stx.base02;
        regular1 = stx.base08;
        regular2 = stx.base0B;
        regular3 = stx.base0A;
        regular4 = stx.base0D;
        regular5 = stx.base0E;
        regular6 = stx.base0C;
        regular7 = stx.base05;
        bright0 = stx.base02;
        bright1 = stx.base08;
        bright2 = stx.base0B;
        bright3 = stx.base0A;
        bright4 = stx.base0D;
        bright5 = stx.base0E;
        bright6 = stx.base0C;
        bright7 = stx.base07;
        "16" = stx.base09;
        "17" = stx.base0F;
        "18" = stx.base01;
        "19" = stx.base02;
        "20" = stx.base04;
        "21" = stx.base06;
      };
    };
  };
}
