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
          matches = [{app-id = "^com.mitchellh.ghostty$";}];
          background-effect = {
            blur = true;
            xray = true;
          };
        }
        {
          matches = [{app-id = "^org\\.gnome\\.eog$";}];
          popups = {
            geometry-corner-radius = {
              top-left = 15.0;
              top-right = 15.0;
              bottom-left = 15.0;
              bottom-right = 15.0;
            };
            opacity = 0.5;
            background-effect.blur = true;
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
