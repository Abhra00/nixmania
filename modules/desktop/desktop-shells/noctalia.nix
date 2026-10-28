{
  flake.modules.nixos.desktop-shell_noctalia = {
    config,
    username,
    ...
  }: {
    sops.templates."noctalia-calendar.toml" = {
      owner = username;
      mode = "0400";
      content = ''
        [calendar]
        enabled = true

        [calendar.account.google_main]
        type = "ics"
        name = "Google"
        server_url = "${config.sops.placeholder.google_ical_url}"

        [calendar.account.holidays]
        type = "ics"
        name = "Holidays"
        server_url = "https://calendar.google.com/calendar/ical/en.indian%23holiday%40group.v.calendar.google.com/public/basic.ics"
      '';
    };

    hm = {
      inputs,
      confDir,
      config,
      osConfig,
      ...
    }: let
      homeDir = config.home.homeDirectory;
      wallpaperDir = "${confDir}/assets/pictures/Wallpapers";
    in {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          audio = {
            enable_overdrive = true;
            enable_sounds = true;
            sound_volume = 1.0;
          };

          backdrop = {
            enabled = true;
          };

          bar.default = {
            capsule_radius = 4;
            capsule_thickness = 0.75;
            center = ["clock"];
            end = ["tray" "group:g1" "group:g2" "session"];
            padding = 15;
            radius = 4;
            start = ["launcher" "wallpaper" "workspaces" "media"];
            thickness = 50;
            widget_spacing = 10;

            capsule_group = [
              {
                accordion = false;
                accordion_direction = "end";
                enabled = true;
                fill = "surface_container";
                id = "g1";
                members = ["recorder" "notifications" "clipboard" "control-center"];
                opacity = 1.0;
                padding = 6.0;
                radius = 4.0;
              }
              {
                accordion = false;
                accordion_direction = "end";
                enabled = true;
                fill = "surface_container";
                id = "g2";
                members = ["network" "bluetooth" "volume" "brightness" "battery"];
                opacity = 1.0;
                padding = 6.0;
                radius = 4.0;
              }
            ];
          };

          brightness = {
            minimum_brightness = 0.8;
            sync_all_monitors = true;
          };

          control_center = {
            width = 800;
            calendar = {
              show_week_numbers = true;
            };
          };

          dock = {
            active_monitor_only = true;
            auto_hide = true;
            enabled = true;
            inactive_opacity = 0.8;
            inactive_scale = 1.0;
            magnification_scale = 1.15;
            radius = 4;
            reserve_space = false;
            show_dots = true;
          };

          idle = {
            behavior_order = ["lock" "screen-off" "lock-and-suspend"];

            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 600.0;
              };
              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 900.0;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 660.0;
              };
            };
          };

          location = {
            address = "Memari,India";
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@eDP-1"
              "lockscreen-widget-0000000000000001"
              "lockscreen-widget-0000000000000002"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@eDP-1" = {
                box_height = 196.0;
                box_width = 810.0;
                cx = 960.0;
                cy = 898.0;
                output = "eDP-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "login_box";

                settings = {
                  background_color = "surface_container";
                  background_opacity = 0.88;
                  background_radius = 12.0;
                  center_password_text = false;
                  input_opacity = 1.0;
                  input_radius = 6.0;
                  layout = "regular";
                  show_caps_lock = true;
                  show_keyboard_layout = true;
                  show_login_button = true;
                  show_media = true;
                  show_session_buttons = true;
                  show_unlock_hint = true;
                  show_weather = true;
                };
              };

              lockscreen-widget-0000000000000001 = {
                box_height = 208.0;
                box_width = 304.0;
                cx = 968.5;
                cy = 567.5;
                output = "eDP-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "clock";

                settings = {
                  background_radius = 4;
                  color = "primary";
                };
              };

              lockscreen-widget-0000000000000002 = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 1760.0;
                cy = 924.0;
                output = "eDP-1";
                placement_height = 1080.0;
                placement_width = 1920.0;
                rotation = 0.0;
                type = "fancy_audio_visualizer";

                settings = {
                  background = false;
                };
              };
            };
          };

          notification = {
            history_retention_hours = 1;
          };

          plugin_settings."noctalia/screen_recorder" = {
            copy_to_clipboard = true;
            filename_pattern = "Recording_%Y%m%d_%H%M%S";
          };

          plugins = {
            enabled = ["noctalia/screen_recorder" "noctalia/wallhaven"];
          };

          shell = {
            avatar_path = "${confDir}/assets/pictures/profile-pictures/pfp.jpg";
            app_icon_color = "primary";
            app_icon_colorize = true;
            clipboard_image_action_command = "noctalia msg annotate {path}";
            corner_radius_scale = 0.4;
            launch_apps_as_systemd_services = true;
            password_style = "random";
            polkit_agent = true;
            screen_time_enabled = true;
            settings_window_translucent = true;
            telemetry_enabled = false;

            animation = {
              speed = 1.45;
            };

            greeter_sync = {
              auto_sync = true;
            };

            launcher = {
              app_grid = true;
              compact = true;
              show_app_actions = true;
              providers = {
                emoji = {
                  global = true;
                };
                panels = {
                  global = true;
                };
                session = {
                  global = true;
                };
                wallpaper = {
                  global = true;
                };
                windows = {
                  global = true;
                };
              };
            };

            panel = {
              clipboard_placement = "attached";
              launcher_placement = "attached";
              list_item_background = true;
              polkit_placement = "attached";
            };

            screen_corners = {
              enabled = true;
              size = 4;
            };

            screenshot = {
              annotate = true;
              confirm_region = true;
              directory = "${homeDir}/Pictures/Screenshots";
              filename_pattern = "Screenshot-%d-%m-%y_%H-%M-%S";
              remember_last_region = true;
              show_cursor = true;
            };

            shadow = {
              alpha = 1.0;
            };

            window_switcher = {
              mru = true;
            };
          };

          wallpaper = {
            directory = wallpaperDir;
            directory_dark = wallpaperDir;
            directory_light = wallpaperDir;
            transition_on_startup = true;
            per_monitor_directories = true;
            monitor.eDP-1 = {
              directory = wallpaperDir;
              directory_dark = wallpaperDir;
              directory_light = wallpaperDir;
            };
          };

          widget = {
            battery = {
              display_mode = "graphic";
              show_label = false;
            };

            brightness = {
              show_label = false;
            };

            clock = {
              anchor = true;
            };

            launcher = {
              custom_image = "${confDir}/assets/pictures/logos/NixOS.svg";
            };

            media = {
              capsule = true;
            };

            network = {
              show_label = false;
            };

            recorder = {
              type = "noctalia/screen_recorder:recorder";
            };

            session = {
              capsule = true;
              capsule_fill = "error";
              capsule_padding = 10;
              color = "on_error";
            };

            volume = {
              show_label = false;
            };

            workspaces = {
              capsule = true;
              style = "focus_hint";
            };
          };
        };
      };

      xdg.configFile."noctalia/calendar.toml".source =
        config.lib.file.mkOutOfStoreSymlink
        osConfig.sops.templates."noctalia-calendar.toml".path;
    };
  };
}
