{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings = {
      layout.shadow.draw-behind-window = true;

      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview*";}];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
            {app-id = "org.gnome.NautilusPreviewer";}
            {app-id = "com.gabm.satty";}
          ];
          open-floating = true;
        }
        {
          geometry-corner-radius = {
            top-left = 2.0;
            top-right = 2.0;
            bottom-left = 2.0;
            bottom-right = 2.0;
          };
          clip-to-geometry = true;
        }
      ];
    };
  };
}
