{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings.input = {
      keyboard = {
        repeat-delay = 300;
        repeat-rate = 35;
        xkb.layout = "us";
      };

      touchpad = {
        tap = true;
        drag = true;
        drag-lock = true;
        natural-scroll = true;
      };

      mouse = {
        accel-profile = "flat";
        accel-speed = 0.2;
      };

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "30%";
      };
    };
  };
}
