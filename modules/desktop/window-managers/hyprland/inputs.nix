{
  flake.modules.nixos.window-manager_hyprland = {config, ...}: let
    xkb = config.services.xserver.xkb;
  in {
    hm.wayland.windowManager.hyprland.settings.config.input = {
      kb_layout = xkb.layout;
      kb_variant = xkb.variant;
      kb_options = xkb.options;
      repeat_delay = config.services.xserver.autoRepeatDelay;
      repeat_rate = 1000 / config.services.xserver.autoRepeatInterval;

      follow_mouse = 1;
      float_switch_override_focus = 0;

      accel_profile = "flat";
      sensitivity = 0.2;

      touchpad = {
        natural_scroll = true;
        tap_to_click = true;
        tap_and_drag = true;
        drag_lock = 1;
        disable_while_typing = true;
      };
    };
  };
}
