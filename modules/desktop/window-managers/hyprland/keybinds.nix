{
  flake.modules.nixos.window-manager_hyprland = {lib, ...}: let
    h = import ./_lib.nix {inherit lib;};
    inherit (h) dsp bind bindRepeat bindLocked bindLockedRepeat bindMouse key mkLuaInline;

    mod = "SUPER";
    m = k: key [mod] k;
    ms = k: key [mod "SHIFT"] k;
    mc = k: key [mod "CTRL"] k;
    ma = k: key [mod "ALT"] k;

    workspaces = lib.genList (i: toString (i + 1)) 9;

    dirKeys = {
      H = "left";
      J = "down";
      K = "up";
      L = "right";
      Left = "left";
      Down = "down";
      Up = "up";
      Right = "right";
    };
    perDir = f: lib.mapAttrsToList f dirKeys;

    # dwindle -> master -> scrolling -> monocle -> dwindle
    cycleLayout = mkLuaInline ''
      function()
        local order = { "dwindle", "master", "scrolling", "monocle" }
        local current = hl.get_config("general.layout")
        local idx = 0
        for i, name in ipairs(order) do
          if name == current then idx = i end
        end
        hl.config({ general = { layout = order[(idx % #order) + 1] } })
      end
    '';

    # Layout message guard
    forLayout = layout: msg:
      mkLuaInline ''
        function()
          if hl.get_config("general.layout") == "${layout}" then
            hl.dispatch(hl.dsp.layout("${msg}"))
          end
        end
      '';

    # Alt+Tab: window.cycle_next
    cycleWindow = forward: let
      monocleMsg =
        if forward
        then "cyclenext"
        else "cycleprev";
    in
      mkLuaInline ''
        function()
          if hl.get_config("general.layout") == "monocle" then
            hl.dispatch(hl.dsp.layout("${monocleMsg}"))
          else
            hl.dispatch(hl.dsp.window.cycle_next({ next = ${lib.boolToString forward} }))
          end
        end
      '';

    # Magnifier-style cursor zoom
    zoom = offset:
      mkLuaInline ''
        function()
          local o = ${offset}
          local cur = hl.get_config("cursor.zoom_factor")
          if o ~= nil then
            cur = cur + o
          elseif cur ~= 1 then
            cur = 1
          else
            cur = 1.5
          end
          cur = math.max(1, math.min(3, cur))
          hl.config({ cursor = { zoom_factor = cur } })
        end
      '';

    # dpms must not be dispatched directly from a bind
    monitorsOff = mkLuaInline ''
      function()
        hl.timer(function()
          hl.dispatch(hl.dsp.dpms({ action = "disable" }))
        end, { timeout = 500, type = "oneshot" })
      end
    '';

    noctalia = args: dsp.exec "noctalia msg ${args}";
    execSd = cmd: dsp.exec "systemd-run --user --scope --slice=app ${cmd}";
  in {
    hm.wayland.windowManager.hyprland = {
      settings.bind = lib.concatLists [
        # Essentials
        [
          (bind (m "Return") (dsp.exec "ghostty +new-window"))
          (bind (m "E") (execSd "nautilus"))
          (bind (m "B") (execSd "firefox"))
          (bind (m "Q") dsp.close)
          (bind (ms "Q") dsp.exit)
          (bind (key ["ALT" "SHIFT"] "L") (noctalia "panel-toggle session"))
          (bind (m "Space") (noctalia "panel-toggle launcher"))
          (bind (ms "C") (dsp.exec "systemctl --user restart noctalia"))
          (bind (ms "V") (noctalia "panel-toggle clipboard"))
          (bind (ms "W") (noctalia "panel-toggle noctalia/wallhaven:browser"))
          (bind (key ["ALT"] "W") (noctalia "window-switcher"))
          (bind (key ["ALT"] "Tab") (cycleWindow true))
          (bind (key ["ALT" "SHIFT"] "Tab") (cycleWindow false))
        ]

        # Screenshots
        [
          (bind "Print" (noctalia "screenshot-region"))
          (bind (key ["CTRL"] "Print") (noctalia "screenshot-fullscreen"))
          (bind (ma "S") (noctalia "screenshot-region"))
          (bind (ma "F") (noctalia "screenshot-fullscreen"))
          (bind (ma "W") (noctalia "screenshot-window"))
        ]

        # Zoom
        [
          (bind (m "Z") (zoom "nil"))
          (bindRepeat (mc "Equal") (zoom "0.5"))
          (bindRepeat (mc "Minus") (zoom "-0.5"))
        ]

        # Focus / move
        (perDir (k: dir: bind (m k) (dsp.focus {direction = dir;})))
        (perDir (k: dir: bind (ms k) (dsp.move {direction = dir;})))

        # Window state
        [
          (bind (m "F") (dsp.fullscreen {mode = "maximized";}))
          (bind (ms "F") (dsp.fullscreen {mode = "fullscreen";}))
          (bind (m "V") (dsp.float {action = "toggle";}))
          (bind (m "C") dsp.center)
        ]

        # Groups
        [
          (bind (m "Tab") dsp.groupToggle)
          (bind (mc "Tab") dsp.groupNext)
          (bind (key [mod "CTRL" "SHIFT"] "Tab") dsp.groupPrev)
          (bind (m "BracketLeft") (dsp.move {into_group = "left";}))
          (bind (m "BracketRight") (dsp.move {into_group = "right";}))
          (bind (ms "BracketLeft") (dsp.move {out_of_group = true;}))
        ]

        # Layouts
        [
          (bind (ma "Space") cycleLayout)
          (bind (m "S") (forLayout "dwindle" "togglesplit"))
          (bind (ms "S") (forLayout "dwindle" "swapsplit"))
          (bind (m "P") dsp.pseudo)
          (bind (ms "Return") (forLayout "master" "swapwithmaster"))
          (bind (m "Comma") (forLayout "master" "addmaster"))
          (bind (m "Period") (forLayout "master" "removemaster"))
          (bind (ma "O") (forLayout "master" "orientationcycle"))
          (bind (m "R") (forLayout "scrolling" "colresize +conf"))
          (bind (mc "R") (forLayout "scrolling" "colresize -conf"))
          (bind (ma "H") (forLayout "scrolling" "swapcol l"))
          (bind (ma "L") (forLayout "scrolling" "swapcol r"))
          (bind (ma "Comma") (forLayout "scrolling" "move -col"))
          (bind (ma "Period") (forLayout "scrolling" "move +col"))
          (bind (ma "BracketLeft") (forLayout "scrolling" "consume_or_expel prev"))
          (bind (ma "BracketRight") (forLayout "scrolling" "consume_or_expel next"))
          (bind (ma "P") (forLayout "scrolling" "promote"))
          (bind (ma "C") (forLayout "scrolling" "center"))
          (bind (ma "Equal") (forLayout "scrolling" "fit visible"))
        ]

        # Workspaces
        [
          (bind (m "Page_Down") (dsp.focus {workspace = "e+1";}))
          (bind (m "Page_Up") (dsp.focus {workspace = "e-1";}))
          (bind (ms "Page_Down") (dsp.move {workspace = "e+1";}))
          (bind (ms "Page_Up") (dsp.move {workspace = "e-1";}))
          (bind (m "mouse_down") (dsp.focus {workspace = "e+1";}))
          (bind (m "mouse_up") (dsp.focus {workspace = "e-1";}))
          (bind (ms "mouse_down") (dsp.move {workspace = "e+1";}))
          (bind (ms "mouse_up") (dsp.move {workspace = "e-1";}))
        ]
        (map (n: bind (m n) (dsp.focus {workspace = n;})) workspaces)
        (map (n: bind (ms n) (dsp.move {workspace = n;})) workspaces)

        # System
        [
          (bind (ms "P") monitorsOff)
          (bind (ms "Escape") (dsp.submap "passthru"))
        ]

        # Resize
        [
          (bindRepeat (m "Equal") (dsp.resize {
            x = 60;
            y = 0;
            relative = true;
          }))
          (bindRepeat (m "Minus") (dsp.resize {
            x = -60;
            y = 0;
            relative = true;
          }))
          (bindRepeat (ms "Equal") (dsp.resize {
            x = 0;
            y = 60;
            relative = true;
          }))
          (bindRepeat (ms "Minus") (dsp.resize {
            x = 0;
            y = -60;
            relative = true;
          }))
        ]

        # Media / brightness
        [
          (bindLockedRepeat "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
          (bindLockedRepeat "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
          (bindLockedRepeat "XF86MonBrightnessUp" (dsp.exec "brightnessctl set +5%"))
          (bindLockedRepeat "XF86MonBrightnessDown" (dsp.exec "brightnessctl set 5%-"))
          (bindLocked "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
          (bindLocked "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
          (bindLocked "XF86AudioPlay" (dsp.exec "playerctl play-pause"))
          (bindLocked "XF86AudioStop" (dsp.exec "playerctl stop"))
          (bindLocked "XF86AudioPrev" (dsp.exec "playerctl previous"))
          (bindLocked "XF86AudioNext" (dsp.exec "playerctl next"))
          (bindLocked "switch:on:Lid Switch" (noctalia "session lock"))
        ]

        # Mouse
        [
          (bindMouse (m "mouse:272") dsp.drag)
          (bindMouse (m "mouse:273") dsp.dragResize)
        ]
      ];

      # "Passthru" submap: the focused app gets every shortcut
      submaps.passthru.settings.bind = [
        (bind (ms "Escape") (dsp.submap "reset"))
      ];
    };
  };
}
