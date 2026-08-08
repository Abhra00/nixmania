{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings = {
      layout.shadow.draw-behind-window = true;

      layer-rules = [
        {
          matches = [{namespace = "^noctalia-backdrop";}];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
            {app-id = "org.gnome.NautilusPreviewer";}
            {app-id = "com.gabm.satty";}
          ];
          open-floating = true;
        }
        {
          matches = [{app-id = "dev.noctalia.Noctalia";}];
          open-floating = true;
          default-column-width = {fixed = 1080;};
          default-window-height = {fixed = 920;};
        }
        {
          matches = [{app-id = "^foot$";}];
          background-effect = {
            blur = true;
            xray = true;
          };
        }
        {
          popups = {
            geometry-corner-radius = {
              top-left = 15.0;
              top-right = 15.0;
              bottom-left = 15.0;
              bottom-right = 15.0;
            };
            background-effect.blur = false;
          };
        }
        {
          geometry-corner-radius = {
            top-left = 4.0;
            top-right = 4.0;
            bottom-left = 4.0;
            bottom-right = 4.0;
          };
          clip-to-geometry = true;
        }
      ];
    };
  };
}
