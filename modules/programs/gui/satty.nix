{
  flake.modules.nixos.gui_satty = {config, ...}: {
    hm.programs.satty = {
      enable = true;
      settings = {
        general = {
          early-exit = true;
          initial-tool = "pointer";
          output-filename = "~/Pictures/Screenshots/satty-%Y%m%d-%H%M%S.png";
          save-after-copy = false;
          fullscreen = false;
          default-hide-toolbars = false;
        };
        color-palette = {
          palette = [
            "#${config.lib.stylix.colors.base08}"
            "#${config.lib.stylix.colors.base0B}"
            "#${config.lib.stylix.colors.base0A}"
            "#${config.lib.stylix.colors.base0D}"
            "#${config.lib.stylix.colors.base0E}"
            "#${config.lib.stylix.colors.base0C}"
          ];
        };
      };
    };
  };
}
