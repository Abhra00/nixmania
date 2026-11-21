{
  flake.modules.nixos.window-manager_hyprland = {
    config,
    lib,
    ...
  }: let
    enabled = config.stylix.enable or false;
    cursor = config.stylix.cursor;
    fonts = config.stylix.fonts;
    stx = config.lib.stylix.colors;

    rgb = c: "rgb(${c})";
    rgba = c: a: "rgba(${c}${a})";
  in {
    hm.wayland.windowManager.hyprland.settings = lib.mkIf enabled {
      config = {
        general.col = {
          active_border = rgb stx.base0D;
          inactive_border = rgb stx.base02;
          nogroup_border = rgb stx.base02;
          nogroup_border_active = rgb stx.base0D;
        };

        group = {
          col = {
            border_active = rgb stx.base0D;
            border_inactive = rgb stx.base02;
            border_locked_active = rgb stx.base0C;
            border_locked_inactive = rgb stx.base03;
          };

          groupbar = {
            col = {
              active = rgb stx.base0D;
              inactive = rgb stx.base02;
              locked_active = rgb stx.base0C;
              locked_inactive = rgb stx.base03;
            };

            text_color = rgb stx.base00;
            text_color_inactive = rgb stx.base05;
            text_color_locked_active = rgb stx.base00;
            text_color_locked_inactive = rgb stx.base05;

            font_family = fonts.sansSerif.name;
            font_size = fonts.sizes.desktop;
            font_weight_active = "bold";
            font_weight_inactive = "normal";
          };
        };

        decoration.shadow = {
          color = rgba stx.base00 "99";
          color_inactive = rgba stx.base00 "55";
        };

        misc = {
          background_color = rgb stx.base00;
          font_family = fonts.sansSerif.name;
        };
      };

      env = lib.optionals (cursor != null) [
        {_args = ["XCURSOR_THEME" cursor.name];}
        {_args = ["XCURSOR_SIZE" (toString cursor.size)];}
        {_args = ["HYPRCURSOR_SIZE" (toString cursor.size)];}
      ];
    };
  };
}
