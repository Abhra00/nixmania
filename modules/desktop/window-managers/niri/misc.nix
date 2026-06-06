{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings = {
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot-%d-%m-%y_%H-%M-%S.png";
      gestures.hot-corners.enable = false;

      environment = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QS_ICON_THEME = "Papirus-Dark";
      };

      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 22;
        hide-when-typing = true;
        hide-after-inactive-ms = 1000;
      };

      spawn-at-startup = [
        {command = ["noctalia-shell"];}
        {sh = "nautilus --gapplication-service &";}
      ];

      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
        "6" = {};
        "7" = {};
        "8" = {};
        "9" = {};
      };
    };
  };
}
