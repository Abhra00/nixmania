{
  flake.modules.nixos.shell_fish = {
    config,
    lib,
    ...
  }: let
    cfg = config.stylix.targets.tide;
    pal = config.lib.stylix.tide-palette.colors;

    set = name: value: "set -g ${name} ${value}";

    sharedBg = pal.bg.shared;
    gitBg = pal.bg.git;
    gitDirtyBg = pal.bg.gitDirty;
    gitUrgentBg = pal.bg.gitUrgent;
    statusBgFailure = pal.bg.statusFailure;
    statusFgFailure = pal.fg.statusFailure;
    separatorColor = pal.separator;
    frameColor = pal.frame;
    vcsFg = pal.fg.vcs;

    gitColorKeys = [
      "branch"
      "conflicted"
      "dirty"
      "operation"
      "staged"
      "stash"
      "untracked"
      "upstream"
    ];

    fg = pal.items;
    viModeColors = pal.viMode;
    contextColors = pal.context;
    pwd = pal.pwd;

    sharedBgVars =
      map (i: "tide_${i}_bg_color") (lib.remove "character" (builtins.attrNames fg) ++ ["context" "pwd"])
      ++ map (m: "tide_vi_mode_bg_color_${m}") (builtins.attrNames viModeColors)
      ++ ["tide_direnv_bg_color_denied"];

    lines =
      lib.mapAttrsToList (item: c: set "tide_${item}_color" c) fg
      ++ lib.mapAttrsToList (k: c: set "tide_pwd_${k}" c) pwd
      ++ lib.mapAttrsToList (k: c: set "tide_vi_mode_color_${k}" c) viModeColors
      ++ lib.mapAttrsToList (k: c: set "tide_context_color_${k}" c) contextColors
      ++ map (v: set v sharedBg) sharedBgVars
      ++ [
        (set "tide_character_color_failure" pal.fg.characterFailure)
        (set "tide_direnv_color_denied" pal.fg.direnvDenied)
        (set "tide_git_bg_color" gitBg)
        (set "tide_git_bg_color_unstable" gitDirtyBg)
        (set "tide_git_bg_color_urgent" gitUrgentBg)
        (set "tide_jj_bg_color" gitBg)
        (set "tide_jj_color" vcsFg)
        (set "tide_status_bg_color_failure" statusBgFailure)
        (set "tide_status_color_failure" statusFgFailure)
        (set "tide_prompt_color_separator_same_color" separatorColor)
        (set "tide_prompt_color_frame_and_connection" frameColor)
      ]
      ++ map (k: set "tide_git_color_${k}" vcsFg) gitColorKeys;
  in {
    options.stylix.targets.tide.enable =
      config.lib.stylix.mkEnableTarget "tide" true;

    config = lib.mkIf (config.stylix.enable && cfg.enable) {
      hm.xdg.configFile."fish/conf.d/tide.fish".text = ''
        ${lib.concatStringsSep "\n" lines}
      '';
    };
  };
}
