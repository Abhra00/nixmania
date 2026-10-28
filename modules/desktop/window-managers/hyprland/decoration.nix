{
  flake.modules.nixos.window-manager_hyprland = {
    hm.wayland.windowManager.hyprland.settings.config.decoration = {
      rounding = 4;
      rounding_power = 2;

      blur = {
        enabled = true;
        size = 3;
        passes = 2;
        noise = 0.02;
        vibrancy = 0.3;
        xray = false;
        popups = true;
        new_optimizations = true;
      };

      shadow = {
        enabled = true;
        range = 24;
        render_power = 3;
        offset = [0 8];
      };
    };
  };
}
