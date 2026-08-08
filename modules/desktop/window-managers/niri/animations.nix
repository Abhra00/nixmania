{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings.animations = {
      workspace-switch.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1200;
        epsilon = 0.0001;
      };

      window-open.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };

      window-close.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };

      horizontal-view-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1200;
        epsilon = 0.0001;
      };

      window-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1200;
        epsilon = 0.0001;
      };

      window-resize.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1200;
        epsilon = 0.0001;
      };

      config-notification-open-close.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };

      exit-confirmation-open-close.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };

      screenshot-ui-open.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };

      overview-open-close.kind.easing = {
        duration-ms = 100;
        curve = "ease-out-cubic";
      };
    };
  };
}
