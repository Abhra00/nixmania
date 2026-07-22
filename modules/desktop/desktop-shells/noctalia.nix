{
  flake.modules.nixos.desktop-shell_noctalia = {
    hm = {
      inputs,
      confDir,
      config,
      ...
    }: {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia.enable = true;
      programs.noctalia.settings = {
        config_version = 2;

        audio = {
          enable_sounds = true;
          sound_volume = 1.0;
        };

        backdrop.enabled = true;

        bar.default = {
          capsule_radius = 4;
          capsule_thickness = 0.75;
          end = [
            "recorder"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "brightness"
            "volume"
            "battery"
            "control-center"
            "session"
          ];
          padding = 15;
          radius = 4;
          start = ["launcher" "wallpaper" "workspaces" "media"];
          thickness = 45;
          widget_spacing = 10;
        };

        calendar.enabled = true;

        desktop_widgets = {
          schema_version = 2;
          widget_order = [];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {};
        };

        idle = {
          behavior_order = ["lock" "screen-off" "lock-and-suspend"];
          pre_action_fade_seconds = 5;
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 600;
            };
            "lock-and-suspend" = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 900;
            };
            "screen-off" = {
              action = "screen_off";
              enabled = true;
              timeout = 660;
            };
          };
        };

        location.address = "Memari,India";

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@eDP-1"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
            "lockscreen-widget-0000000000000005"
            "lockscreen-widget-0000000000000006"
            "lockscreen-widget-0000000000000007"
            "lockscreen-widget-0000000000000008"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@eDP-1" = {
              box_height = 70.0;
              box_width = 400.0;
              cx = 960.0;
              cy = 957.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "login_box";
              settings = {
                center_password_text = false;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 688.0;
              box_width = 896.0;
              cx = 992.0;
              cy = 380.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "fancy_audio_visualizer";
              settings.background = false;
            };

            "lockscreen-widget-0000000000000002" = {
              box_height = 96.0;
              box_width = 272.0;
              cx = 1768.0;
              cy = 60.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "clock";
              settings = {
                background_color = "surface";
                color = "secondary";
              };
            };

            "lockscreen-widget-0000000000000003" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 960.0;
              cy = 812.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "media_player";
            };

            "lockscreen-widget-0000000000000005" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1888.0;
              cy = 892.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                color = "on_secondary";
                command = "systemctl reboot";
                glyph = "reboot";
                variant = "secondary";
              };
            };

            "lockscreen-widget-0000000000000006" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1888.0;
              cy = 992.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                color = "on_tertiary";
                command = "systemctl suspend";
                glyph = "moon-filled";
                label = "";
                variant = "primary";
              };
            };

            "lockscreen-widget-0000000000000007" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1888.0;
              cy = 942.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "button";
              settings = {
                background = true;
                color = "on_primary";
                command = "systemctl poweroff";
                glyph = "shutdown";
                hover_background = "primary";
                variant = "destructive";
              };
            };

            "lockscreen-widget-0000000000000008" = {
              box_height = 96.0;
              box_width = 272.0;
              cx = 1768.0;
              cy = 172.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "weather";
              settings.color = "primary";
            };
          };
        };

        notification.background_opacity = 1.0;

        osd.background_opacity = 1.0;

        plugin_settings."noctalia/wallhaven".download_dir = "${config.home.homeDirectory}/Pictures/Wallpapers";

        plugins.enabled = ["noctalia/wallhaven" "noctalia/screen_recorder"];

        shell = {
          app_icon_color = "tertiary";
          avatar_path = "${confDir}/assets/pictures/profile-pictures/pfp.jpg";
          clipboard_image_action_command = "satty -f -";
          corner_radius_scale = 0.4;
          launch_apps_as_systemd_services = true;
          niri_overview_type_to_launch_enabled = true;
          password_style = "random";
          screen_time_enabled = true;
          telemetry_enabled = true;

          panel = {
            clipboard_placement = "attached";
            launcher_placement = "attached";
          };

          screen_corners = {
            enabled = true;
            size = 4;
          };

          screenshot = {
            directory = "${config.home.homeDirectory}/Pictures/Screenshots";
            filename_pattern = "Screenshot-%d-%m-%y_%H-%M-%S";
          };
        };

        theme = {
          community_palette = "Tokyo Night Moon";
          custom_palette = "stylix";
          mode = "dark";
          source = "custom";
        };

        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          per_monitor_directories = true;
          transition_duration = 2200;
          transition_on_startup = true;

          default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.jpg";
          last.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.jpg";

          monitor."eDP-1".directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          monitors."eDP-1".path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.jpg";
        };

        widget = {
          battery = {
            display_mode = "graphic";
            show_label = false;
          };

          brightness.show_label = false;

          launcher = {
            anchor = true;
            capsule_padding = 10.0;
            capsule_radius = 4;
            custom_image = "${confDir}/assets/pictures/logos/NixOS.svg";
            scale = 1.0;
          };

          network.show_label = false;

          recorder.type = "noctalia/screen_recorder:recorder";

          session.capsule_radius = 4;

          volume.show_label = false;

          wallhaven.type = "noctalia/wallhaven:wallhaven";

          workspaces = {
            capsule_radius = 4;
            display = "name";
            labels_only_when_occupied = true;
          };
        };
      };
    };
  };
}
