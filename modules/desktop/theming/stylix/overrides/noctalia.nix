{
  flake.modules.nixos.desktop-shell_noctalia = {
    config,
    lib,
    ...
  }: let
    enabled = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;
    name = "stylix";
    mode =
      if config.stylix.polarity == "light"
      then "light"
      else "dark";

    ansi = {
      black = stx.base00;
      red = stx.base08;
      green = stx.base0B;
      yellow = stx.base0A;
      blue = stx.base0D;
      magenta = stx.base0E;
      cyan = stx.base0C;
      white = stx.base05;
    };

    variant = {
      mPrimary = stx.base0D;
      mOnPrimary = stx.base00;
      mSecondary = stx.base0E;
      mOnSecondary = stx.base00;
      mTertiary = stx.base0C;
      mOnTertiary = stx.base00;
      mError = stx.base08;
      mOnError = stx.base00;
      mSurface = stx.base00;
      mOnSurface = stx.base05;
      mSurfaceVariant = stx.base01;
      mOnSurfaceVariant = stx.base04;
      mOutline = stx.base03;
      mShadow = stx.base00;
      mHover = stx.base02;
      mOnHover = stx.base05;

      terminal = {
        background = stx.base00;
        foreground = stx.base05;
        cursor = stx.base05;
        cursorText = stx.base00;
        selectionBg = stx.base02;
        selectionFg = stx.base05;
        normal = ansi;
        bright =
          ansi
          // {
            black = stx.base03;
            white = stx.base07;
          };
      };
    };
  in {
    hm.programs.noctalia = lib.mkIf enabled {
      settings =
        {
          theme = {
            source = "custom";
            custom_palette = name;
            inherit mode;
          };

          dock.background_opacity = config.stylix.opacity.desktop;
          notification.background_opacity = config.stylix.opacity.popups;
          osd.background_opacity = config.stylix.opacity.popups;

          shell.font_family = config.stylix.fonts.sansSerif.name;
        }
        // lib.optionalAttrs (config.stylix.image != null) {
          wallpaper.default.path = toString config.stylix.image;
        };

      customPalettes.${name} = {
        dark = variant;
        light = variant;
      };
    };
  };
}
