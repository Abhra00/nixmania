{
  flake.modules.nixos.gui_foot = {
    hm.programs.foot = {
      enable = true;

      settings = {
        main.pad = "30x30 center-when-maximized-and-fullscreen";
        mouse.hide-when-typing = "yes";

        cursor = {
          blink = "yes";
          blink-rate = 1000;
          style = "block";
        };
      };
    };
  };
}
