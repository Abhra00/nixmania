{
  flake.modules.nixos.window-manager_hyprland = {lib, ...}: let
    hl = import ./_lib.nix {inherit lib;};
  in {
    hm.wayland.windowManager.hyprland.settings = {
      config = {
        general = {
          layout = "dwindle";
          gaps_in = 4;
          gaps_out = 8;
          border_size = 1;
          resize_on_border = true;
          allow_tearing = false;

          snap = {
            enabled = true;
            respect_gaps = true;
          };
        };

        dwindle = {
          preserve_split = true;
          force_split = 2;
          smart_resizing = true;
          use_active_for_splits = true;
        };

        master = {
          new_status = "slave";
          new_on_top = false;
          mfact = 0.55;
          orientation = "left";
          smart_resizing = true;
          drop_at_cursor = true;
          slave_count_for_center_master = 2;
        };

        scrolling = {
          column_width = 0.5;
          explicit_column_widths = "0.25, 0.5, 0.75";
          fullscreen_on_one_column = true;
          follow_focus = true;
          focus_fit_method = 1;
          follow_min_visible = 0.4;
          wrap_focus = true;
        };

        group = {
          auto_group = true;
          insert_after_current = true;
          focus_removed_window = true;
          drag_into_group = 1;
          groupbar = {
            enabled = true;
            height = 25;
            gradients = true;
            gradient_rounding = 4;
            gradient_rounding_power = 2.0;
            gradient_round_only_edges = true;
            indicator_height = 0;
            render_titles = true;
            text_padding = 10;
            keep_upper_gap = false;
            gaps_in = 1;
            gaps_out = 0;
          };
        };

        binds = {
          movefocus_cycles_fullscreen = true;
          workspace_back_and_forth = 1;
          drag_threshold = 10;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          focus_on_activate = true;
          animate_manual_resizes = true;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
          allow_session_lock_restore = true;

          # Terminal swallows GUI apps
          enable_swallow = true;
          swallow_regex = "^(com\\.mitchellh\\.ghostty)$";
        };

        cursor = {
          hide_on_key_press = true;
          inactive_timeout = 1;
          zoom_disable_aa = true;
        };

        render.direct_scanout = 2;

        xwayland.force_zero_scaling = true;

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };

      # Workspaces
      workspace_rule =
        lib.genList (i: {
          workspace = toString (i + 1);
          persistent = true;
        })
        9;

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

      env = [
        (hl.env "NIXOS_OZONE_WL" "1")
        (hl.env "QT_QPA_PLATFORM" "wayland")
      ];
    };
  };
}
