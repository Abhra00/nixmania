{
  flake.modules.nixos.gui_mpv = {
    config,
    lib,
    pkgs,
    ...
  }: {
    hm.programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.modernz];
      config = {
        hwdec = "auto-safe";
        vo = "gpu";
        gpu-context = "wayland";
        keep-open = true;
        save-position-on-quit = true;
        audio-file-auto = "fuzzy";
        volume = 100;
        sub-auto = "fuzzy";
        watch-later-options-remove = "sub-pos";
      };
      bindings = {
        l = "seek 5";
        h = "seek -5";
        j = "add volume -2";
        k = "add volume 2";
        "shift+l" = "seek 30";
        "shift+h" = "seek -30";
      };
    };
  };
}
