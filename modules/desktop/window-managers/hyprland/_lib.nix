# Helpers so Hyprland's Lua config can be written in plain Nix.
{lib}: let
  inherit (lib.generators) mkLuaInline;
  toLua = lib.generators.toLua {multiline = false;};
  luaStr = builtins.toJSON;
  call = fn: args: mkLuaInline "${fn}(${toLua args})";
in rec {
  inherit mkLuaInline luaStr;

  # hl.dsp.* dispatchers
  dsp = {
    exec = cmd: mkLuaInline "hl.dsp.exec_cmd(${luaStr cmd})";
    exit = mkLuaInline "hl.dsp.exit()";
    close = mkLuaInline "hl.dsp.window.close()";
    center = mkLuaInline "hl.dsp.window.center()";
    pseudo = mkLuaInline "hl.dsp.window.pseudo()";
    drag = mkLuaInline "hl.dsp.window.drag()";
    dragResize = mkLuaInline "hl.dsp.window.resize()";
    groupToggle = mkLuaInline "hl.dsp.group.toggle()";
    groupNext = mkLuaInline "hl.dsp.group.next()";
    groupPrev = mkLuaInline "hl.dsp.group.prev()";
    focus = call "hl.dsp.focus";
    move = call "hl.dsp.window.move";
    resize = call "hl.dsp.window.resize";
    fullscreen = call "hl.dsp.window.fullscreen";
    float = call "hl.dsp.window.float";
    cycleNext = call "hl.dsp.window.cycle_next";
    dpms = call "hl.dsp.dpms";
    layout = msg: mkLuaInline "hl.dsp.layout(${luaStr msg})";
    submap = name: mkLuaInline "hl.dsp.submap(${luaStr name})";
  };

  # "SUPER + SHIFT + Q"
  key = mods: k: lib.concatStringsSep " + " (mods ++ [k]);

  # hl.bind(key, action, opts?)
  bind = k: action: {_args = [k action];};
  bindWith = opts: k: action: {_args = [k action opts];};
  bindRepeat = bindWith {repeating = true;};
  bindLocked = bindWith {locked = true;};
  bindLockedRepeat = bindWith {
    locked = true;
    repeating = true;
  };
  bindMouse = bindWith {mouse = true;};

  # hl.env(name, value)
  env = name: value: {_args = [name (toString value)];};

  # hl.on(event, function() ... end)
  on = event: body: {_args = [event (mkLuaInline body)];};
}
