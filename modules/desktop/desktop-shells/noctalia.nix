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
        config_version = 11;

        audio = {
          enable_sounds = true;
          sound_volume = 1.0;
        };

        backdrop.enabled = true;

        bar.default = {
          capsule_radius = 4;
          capsule_thickness = 0.75;
          capsule_group = [
            {
              enabled = true;
              fill = "surface_variant";
              id = "g1";
              members = ["network" "bluetooth" "brightness" "volume" "battery"];
              opacity = 1.0;
              padding = 6.0;
              radius = 4.0;
            }
            {
              enabled = true;
              fill = "surface_variant";
              id = "g2";
              members = ["notifications" "clipboard" "control-center"];
              opacity = 1.0;
              padding = 6.0;
              radius = 4.0;
            }
          ];
          end = [
            "recorder"
            "tray"
            "group:g1"
            "group:g2"
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
            "lockscreen-widget-0000000000000004"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@eDP-1" = {
              box_height = 201.0;
              box_width = 720.0;
              cx = 960.0;
              cy = 957.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "login_box";
              settings = {
                center_password_text = false;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_weather = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 320.0;
              box_width = 432.0;
              cx = 1688.0;
              cy = 897.5;
              output = "eDP-1";
              rotation = 0.0;
              type = "fancy_audio_visualizer";
              settings.background = false;
            };

            "lockscreen-widget-0000000000000004" = {
              box_height = 304.0;
              box_width = 352.0;
              cx = 960.0;
              cy = 540.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "clock";
              settings = {
                background = true;
                background_color = "surface";
                background_opacity = 0.8;
                background_padding = 10;
                background_radius = 12;
                center_text = true;
                circle = true;
                clock_style = "digital";
                color = "primary";
                font_family = "";
                format = "{:%H:%M}";
                shadow = true;
                timezone = "";
              };
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

          default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.png";
          last.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.png";

          monitor."eDP-1".directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          monitors."eDP-1".path = "${config.home.homeDirectory}/Pictures/Wallpapers/Wallpaper.png";
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

          session = {
            capsule = true;
            capsule_fill = "error";
            capsule_foreground = "on_error";
            capsule_padding = 10;
          };

          volume.show_label = false;

          wallhaven.type = "noctalia/wallhaven:wallhaven";

          workspaces = {
            capsule_radius = 4;
            show_labels = true;
            label_source = "name";
            labels_only_when_occupied = true;
            style = "focus_hint";
            capsule = true;
          };
          media = {
            color = "primary";
          };
        };
      };
    };
  };
}
