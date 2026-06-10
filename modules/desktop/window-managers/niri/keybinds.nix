{
  flake.modules.nixos.window-manager_niri = {
    hm.programs.niri.settings.binds = {
      # Essentials
      "Mod+Return".action.spawn-sh = "ghostty +new-window";
      "Mod+E".action.spawn = "nautilus";
      "Mod+B".action.spawn = "firefox-devedition";
      "Mod+Q".action.close-window = {};
      "Alt+Shift+L".action.spawn-sh = "noctalia msg panel-toggle session";
      "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
      "Mod+Shift+C".action.spawn-sh = "noctalia msg config-reload";
      "Mod+Shift+V".action.spawn-sh = "noctalia msg panel-toggle clipboard";
      "Mod+Shift+Q".action.quit = {};
      "Alt+Tab" = {
        action.toggle-overview = {};
        repeat = false;
      };
      "Print".action.spawn-sh = "niri msg action screenshot";
      "Alt+Print".action.screenshot-window = {};
      "Ctrl+Print".action.spawn-sh = "noctalia msg screenshot-fullscreen";

      # Navigation (h j k l)
      "Mod+H".action.focus-column-left = {};
      "Mod+J".action.focus-window-down = {};
      "Mod+K".action.focus-window-up = {};
      "Mod+L".action.focus-column-right = {};

      # Navigation (🡐 🡒 🡑 🡓)
      "Mod+Left".action.focus-column-left = {};
      "Mod+Down".action.focus-window-down = {};
      "Mod+Up".action.focus-window-up = {};
      "Mod+Right".action.focus-column-right = {};

      # Move (h j k l)
      "Mod+Shift+H".action.move-column-left = {};
      "Mod+Shift+J".action.move-window-down = {};
      "Mod+Shift+K".action.move-window-up = {};
      "Mod+Shift+L".action.move-column-right = {};

      # Move (🡐 🡒 🡑 🡓)
      "Mod+Shift+Left".action.move-column-left = {};
      "Mod+Shift+Down".action.move-window-down = {};
      "Mod+Shift+Up".action.move-window-up = {};
      "Mod+Shift+Right".action.move-column-right = {};

      # Resize
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Ctrl+R".action.reset-window-height = {};
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+Shift+R".action.switch-preset-window-height = {};

      # Column & floating
      "Mod+C".action.center-column = {};
      "Mod+V".action.toggle-window-floating = {};
      "Mod+Tab".action.toggle-column-tabbed-display = {};
      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Page_Down".action.focus-workspace-down = {};
      "Mod+Page_Up".action.focus-workspace-up = {};

      # Move to workspace
      "Mod+Shift+1".action.move-window-to-workspace = 1;
      "Mod+Shift+2".action.move-window-to-workspace = 2;
      "Mod+Shift+3".action.move-window-to-workspace = 3;
      "Mod+Shift+4".action.move-window-to-workspace = 4;
      "Mod+Shift+5".action.move-window-to-workspace = 5;
      "Mod+Shift+6".action.move-window-to-workspace = 6;
      "Mod+Shift+7".action.move-window-to-workspace = 7;
      "Mod+Shift+8".action.move-window-to-workspace = 8;
      "Mod+Shift+9".action.move-window-to-workspace = 9;
      "Mod+Shift+Page_Down".action.move-window-to-workspace-down = {};
      "Mod+Shift+Page_Up".action.move-window-to-workspace-up = {};

      # Move workspace
      "Mod+Ctrl+Page_Down".action.move-workspace-down = {};
      "Mod+Ctrl+Page_Up".action.move-workspace-up = {};

      # System
      "Mod+Shift+Escape" = {
        action.toggle-keyboard-shortcuts-inhibit = {};
        allow-inhibiting = false;
      };
      "Mod+Shift+P".action.power-off-monitors = {};
      "XF86AudioRaiseVolume" = {
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        allow-when-locked = true;
      };
      "XF86AudioPlay" = {
        action.spawn = ["playerctl" "play-pause"];
        allow-when-locked = true;
      };
      "XF86AudioStop" = {
        action.spawn = ["playerctl" "stop"];
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action.spawn = ["playerctl" "previous"];
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action.spawn = ["playerctl" "next"];
        allow-when-locked = true;
      };
      "XF86MonBrightnessUp" = {
        action.spawn = ["brightnessctl" "set" "+5%"];
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action.spawn = ["brightnessctl" "set" "5%-"];
        allow-when-locked = true;
      };

      # Mouse
      "Mod+WheelScrollLeft" = {
        action.focus-column-left = {};
        cooldown-ms = 300;
      };
      "Mod+WheelScrollDown" = {
        action.focus-workspace-down = {};
        cooldown-ms = 150;
      };
      "Mod+WheelScrollUp" = {
        action.focus-workspace-up = {};
        cooldown-ms = 150;
      };
      "Mod+WheelScrollRight" = {
        action.focus-column-right = {};
        cooldown-ms = 300;
      };
      "Mod+Shift+WheelScrollLeft".action.move-column-left = {};
      "Mod+Shift+WheelScrollDown" = {
        action.move-column-to-workspace-down = {};
        cooldown-ms = 150;
      };
      "Mod+Shift+WheelScrollUp" = {
        action.move-column-to-workspace-up = {};
        cooldown-ms = 150;
      };
      "Mod+Shift+WheelScrollRight".action.move-column-right = {};
    };
  };
}
