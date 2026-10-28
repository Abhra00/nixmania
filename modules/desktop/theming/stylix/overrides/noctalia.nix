{
  flake.modules.nixos.desktop-shell_noctalia = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;
    theme = "stylix";
    polarity = config.stylix.polarity;
    variant =
      if polarity == "dark"
      then "dark"
      else "light";
    palette = {
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
      mHover = stx.base0E;
      mOnHover = stx.base00;

      terminal = {
        foreground = stx.base05;
        background = stx.base00;
        cursor = stx.base05;
        cursorText = stx.base00;
        selectionFg = stx.base05;
        selectionBg = stx.base02;
        normal = {
          black = stx.base03;
          red = stx.base08;
          green = stx.base0B;
          yellow = stx.base0A;
          blue = stx.base0D;
          magenta = stx.base0E;
          cyan = stx.base0C;
          white = stx.base05;
        };
        bright = {
          black = stx.base03;
          red = stx.base08;
          green = stx.base0B;
          yellow = stx.base0A;
          blue = stx.base0D;
          magenta = stx.base0E;
          cyan = stx.base0C;
          white = stx.base05;
        };
      };
    };
  in {
    hm.programs.noctalia = lib.mkIf cfg {
      settings = {
        theme = {
          source = "custom";
          custom_palette = theme;
          mode = variant;
        };

        dock.background_opacity = config.stylix.opacity.desktop;
        notification.background_opacity = config.stylix.opacity.popups;
        osd.background_opacity = config.stylix.opacity.popups;

        shell.font_family = config.stylix.fonts.sansSerif.name;

        wallpaper.default.path = toString config.stylix.image;
      };

      customPalettes.${theme}.${variant} = palette;
    };
  };
}
