{
  flake.modules.nixos.window-manager_hyprland = let
    dlg = rule:
      rule
      // {
        float = true;
        center = true;
      };
  in {
    hm.wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          name = "no-shadow-tiled";
          match.float = false;
          no_shadow = true;
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }

        {
          name = "firefox-workspace";
          match.class = "^firefox$";
          workspace = "3";
        }

        (dlg {
          name = "portal-dialogs";
          match.class = "^xdg-desktop-portal-gtk$";
          size = ["monitor_w * 0.55" "monitor_h * 0.65"];
          dim_around = true;
        })
        (dlg {
          name = "toolkit-file-dialogs";
          match.title = "^(Open Files?|Open Folder|Save( File| As)?|File Upload|Select (a )?(File|Files|Folder).*|Choose.*|Export.*|Import.*|Upload.*)$";
          size = ["monitor_w * 0.55" "monitor_h * 0.65"];
        })

        (dlg {
          name = "nautilus-dialogs";
          match = {
            class = "^org\\.gnome\\.Nautilus$";
            title = "^(.*Properties|Open With.*|Preferences|Compress.*|Extract.*)$";
          };
        })

        {
          name = "browser-sharing-indicator";
          match = {
            class = "^firefox$";
            title = "^.*Sharing Indicator$";
          };
          float = true;
          pin = true;
          no_initial_focus = true;
          no_focus = true;
        }
        (dlg {
          name = "browser-library";
          match = {
            class = "^firefox$";
            title = "^(Library|About (Mozilla )?Firefox.*)$";
          };
          size = [900 600];
        })
        {
          name = "browser-pip";
          match = {
            class = "^firefox$";
            title = "^Picture-in-Picture$";
          };
          float = true;
          pin = true;
          keep_aspect_ratio = true;
          no_initial_focus = true;
          size = [600 340];
          move = ["monitor_w - window_w - 24" "monitor_h - window_h - 24"];
        }

        (dlg {
          name = "noctalia-window";
          match.class = "^dev\\.noctalia\\.Noctalia$";
          size = [1080 900];
        })

        {
          name = "inhibit-idle-fullscreen-media";
          match.class = "^(mpv|firefox)$";
          idle_inhibit = "fullscreen";
        }
      ];

      layer_rule = [
        {
          name = "noctalia";
          match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.5;
          no_anim = true;
          xray = true;
        }
      ];
    };
  };
}
