{
  flake.modules.nixos.TR-100-machine_display = {
    config,
    lib,
    ...
  }: let
    display = {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refresh = 120.002;
    };
  in {
    hm.programs.niri.settings = lib.mkIf config.programs.niri.enable {
      outputs.${display.name} = {
        mode = {inherit (display) width height refresh;};
        scale = 1;
      };

      debug = {
        honor-xdg-activation-with-invalid-serial = {};
        ignore-drm-device = "/dev/dri/by-path/pci-0000:01:00.0-render";
        render-drm-device = "/dev/dri/by-path/pci-0000:05:00.0-render";
      };
    };
  };
}
