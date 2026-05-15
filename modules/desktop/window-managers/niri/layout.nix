{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings.layout = {
      always-center-single-column = true;
      background-color = "transparent";
      center-focused-column = "never";
      default-column-width = {proportion = 0.50;};
      gaps = 8;

      preset-column-widths = [
        {proportion = 0.25;}
        {proportion = 0.50;}
        {proportion = 0.75;}
      ];

      focus-ring = {
        enable = false;
        width = 3;
      };

      border = {
        enable = true;
        width = 1;
      };

      shadow = {
        enable = false;
        draw-behind-window = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
      };

      tab-indicator = {
        width = 12;
        gap = 8;
        corner-radius = 4;
        length.total-proportion = 1.0;
        place-within-column = true;
        position = "left";
      };

      struts = {
        left = 8;
        right = 8;
        top = 8;
        bottom = 8;
      };
    };
  };
}
