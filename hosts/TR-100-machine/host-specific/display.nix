{
  flake.modules.nixos.TR-100-machine = {
    config,
    lib,
    ...
  }: let
    display = {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refresh = 120;
    };
  in {
    hm.wayland.windowManager.hyprland.settings = lib.mkIf config.programs.hyprland.enable {
      monitor = {
        output = display.name;
        mode = "${toString display.width}x${toString display.height}@${toString display.refresh}";
        position = "0x0";
        scale = 1;
      };

      env = [
        {_args = ["AQ_DRM_DEVICES" "/dev/dri/amd-igpu"];}
      ];
    };
  };
}
