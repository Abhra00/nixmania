{
  flake.modules.nixos.desktop-shell_noctalia = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.enable or false;
    stx = config.lib.stylix.colors.withHashtag;
    termColors = {
      foreground = stx.base05;
      background = stx.base00;
      cursor = stx.base05;
      cursorText = stx.base00;
      selectionFg = stx.base05;
      selectionBg = stx.base03;
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
    schemeColors = {
      mPrimary = stx.base0A;
      mOnPrimary = stx.base00;
      mSecondary = stx.base0B;
      mOnSecondary = stx.base00;
      mTertiary = stx.base0C;
      mOnTertiary = stx.base00;
      mError = stx.base08;
      mOnError = stx.base00;
      mSurface = stx.base00;
      mOnSurface = stx.base05;
      mSurfaceVariant = stx.base02;
      mOnSurfaceVariant = stx.base04;
      mOutline = stx.base03;
      mShadow = stx.base00;
      mHover = stx.base0E;
      mOnHover = stx.base00;
      terminal = termColors;
    };
  in {
    hm.home.file.".config/noctalia/palettes/stylix.json".text = lib.mkIf cfg (
      builtins.toJSON {
        dark = schemeColors;
        light = schemeColors;
      }
    );
  };
}
