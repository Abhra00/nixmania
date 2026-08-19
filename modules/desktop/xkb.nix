{
  flake.modules.nixos.desktop_xkb = {
    services.xserver = {
      xkb.layout = "us";

      autoRepeatDelay = 300;
      autoRepeatInterval = 35;
    };
  };
}
