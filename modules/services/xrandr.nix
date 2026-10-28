{
  flake.modules.nixos.service_xrandr = {pkgs, ...}: {
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080 --rate 60
    '';
  };
}
