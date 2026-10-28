{
  flake.modules.nixos.shell_fish = {lib, ...}: let
    set = name: value: "set -g ${name} ${value}";

    glyph = cp: let
      h = lib.toLower cp;
    in
      if cp == ""
      then "''"
      else if lib.stringLength h > 4
      then "\\U${lib.fixedWidthString 8 "0" h}"
      else "\\u${h}";

    pair = left: right: {inherit left right;};

    style = {
      separators = "slanted";
      heads = "sharp";
      tails = "round";
      connection = "disconnected";
    };

    sharedBg = "303030";
    gitBg = "268BD2";
    gitDirtyBg = "C4A000";
    gitUrgentBg = "CC0000";
    statusBgFailure = "CC0000";
    statusFgFailure = "FFFF00";
    separatorColor = "949494";
    frameColor = "6C6C6C";

    vcsFg = "000000";

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

    fg = {
      status = "5FAF00";
      cmd_duration = "87875F";
      jobs = "5FAF00";
      direnv = "D7AF00";
      bun = "FBF0DF";
      node = "44883E";
      python = "00AFAF";
      rustc = "F74C00";
      java = "ED8B00";
      php = "617CBE";
      pulumi = "F7BF2A";
      ruby = "B31209";
      go = "00ACD7";
      gcloud = "4285F4";
      kubectl = "326CE5";
      distrobox = "FF00FF";
      toolbox = "613583";
      terraform = "844FBA";
      aws = "FF9900";
      nix_shell = "7EBAE4";
      crystal = "FFFFFF";
      elixir = "4E2A8E";
      zig = "F7A41D";
      time = "5F8787";
      character = "5FD700";
      os = "EEEEEE";
      private_mode = "FFFFFF";
      sudo = "F1C40F";
      shlvl = "d78700";
      docker = "2496ED";
    };

    viModeColors = {
      default = "949494";
      insert = "87AFAF";
      replace = "87AF87";
      visual = "FF8700";
    };

    contextColors = {
      default = "D7AF87";
      root = "D7AF00";
      ssh = "D7AF87";
    };

    pwd = {
      color_anchors = "00AFFF";
      color_dirs = "0087AF";
      color_truncated_dirs = "8787AF";
    };

    sharedBgItems =
      builtins.attrNames fg
      ++ [
        "context"
        "pwd"
        "vi_mode_bg_color_default"
        "vi_mode_bg_color_insert"
        "vi_mode_bg_color_replace"
        "vi_mode_bg_color_visual"
        "direnv_bg_color_denied"
        "docker"
      ];

    noIcons = ["cmd_duration_icon" "pwd_icon" "pwd_icon_home"];

    icons = {
      aws = "f270";
      bun = "f0cd3";
      character = "276f";
      crystal = "e62f";
      direnv = "25bc";
      distrobox = "f01a7";
      docker = "f308";
      elixir = "e62d";
      gcloud = "f02ad";
      git = "e0a0";
      go = "e627";
      java = "e256";
      jobs = "f013";
      jj = "f0e8";
      kubectl = "f10fe";
      nix_shell = "f313";
      node = "e24f";
      os = "f313";
      php = "e608";
      private_mode = "f05f9";
      pulumi = "f1b2";
      python = "f0320";
      ruby = "e23e";
      rustc = "e7a8";
      shlvl = "f120";
      status = "2714";
      sudo = "f140b";
      terraform = "f1062";
      toolbox = "e24f";
      zig = "e6a9";
    };

    iconVariants = {
      pwd_icon_unwritable = "f023";
      status_icon_failure = "2718";
      character_vi_icon_default = "276e";
      character_vi_icon_replace = "25b6";
    };

    textIcons = {
      character_vi_icon_visual = "V";
      vi_mode_icon_default = "D";
      vi_mode_icon_insert = "I";
      vi_mode_icon_replace = "R";
      vi_mode_icon_visual = "V";
    };

    scalars = {
      tide_character_color_failure = "FF0000";
      tide_cmd_duration_decimals = "0";
      tide_cmd_duration_threshold = "3000";
      tide_context_always_display = "false";
      tide_context_hostname_parts = "1";
      tide_direnv_color_denied = "FF0000";
      tide_docker_default_contexts = "default colima";
      tide_git_truncation_length = "24";
      tide_git_truncation_strategy = "''";
      tide_jobs_number_threshold = "1000";
      tide_left_prompt_frame_enabled = "false";
      tide_left_prompt_items = "pwd vcs newline character";
      tide_prompt_add_newline_before = "true";
      tide_prompt_min_cols = "34";
      tide_prompt_pad_items = "true";
      tide_prompt_transient_enabled = "false";
      tide_pwd_markers = ".bzr .citc .git .hg .jj .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform bun.lockb Cargo.toml composer.json CVS go.mod package.json build.zig";
      tide_right_prompt_frame_enabled = "false";
      tide_right_prompt_items = "status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig time";
      tide_shlvl_threshold = "1";
      tide_time_format = "'%T'";
    };

    separators = {
      angled = {
        same = pair "e0b1" "e0b3";
        diff = pair "e0b0" "e0b2";
      };
      vertical = {
        same = pair "2502" "2502";
        diff = pair "" "";
      };
      slanted = {
        same = pair "2571" "2571";
        diff = pair "e0bc" "e0ba";
      };
      round = {
        same = pair "e0b5" "e0b7";
        diff = pair "e0b4" "e0b6";
      };
    };

    heads = {
      sharp = pair "e0b0" "e0b2";
      slanted = pair "e0bc" "e0ba";
      round = pair "e0b4" "e0b6";
    };

    tails = {
      flat = pair "" "";
      sharp = pair "e0b2" "e0b0";
      slanted = pair "e0ba" "e0bc";
      round = pair "e0b6" "e0b4";
    };

    connections = {
      solid = glyph "2500";
      dotted = glyph "00b7";
      disconnected = "' '";
    };

    sep = separators.${style.separators};
    head = heads.${style.heads};
    tail = tails.${style.tails};

    lines =
      lib.mapAttrsToList (item: c: set "tide_${item}_color" c) fg
      ++ lib.mapAttrsToList (k: c: set "tide_pwd_${k}" c) pwd
      ++ lib.mapAttrsToList (k: c: set "tide_vi_mode_color_${k}" c) viModeColors
      ++ lib.mapAttrsToList (k: c: set "tide_context_color_${k}" c) contextColors
      ++ map (item: set "tide_${item}_bg_color" sharedBg) sharedBgItems
      ++ lib.mapAttrsToList (name: val: set name val) scalars
      ++ [
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
      ++ map (k: set "tide_git_color_${k}" vcsFg) gitColorKeys
      ++ map (name: "set -g tide_${name}") noIcons
      ++ lib.mapAttrsToList (item: cp: set "tide_${item}_icon" (glyph cp)) icons
      ++ lib.mapAttrsToList (name: cp: set "tide_${name}" (glyph cp)) iconVariants
      ++ lib.mapAttrsToList (name: s: set "tide_${name}" s) textIcons
      ++ [
        (set "tide_left_prompt_separator_same_color" (glyph sep.same.left))
        (set "tide_right_prompt_separator_same_color" (glyph sep.same.right))
        (set "tide_left_prompt_separator_diff_color" (glyph sep.diff.left))
        (set "tide_right_prompt_separator_diff_color" (glyph sep.diff.right))
        (set "tide_left_prompt_suffix" (glyph head.left))
        (set "tide_right_prompt_prefix" (glyph head.right))
        (set "tide_left_prompt_prefix" (glyph tail.left))
        (set "tide_right_prompt_suffix" (glyph tail.right))
        (set "tide_prompt_icon_connection" connections.${style.connection})
      ];
  in {
    hm.xdg.configFile."fish/conf.d/tide.fish".text = ''
      ${lib.concatStringsSep "\n" lines}
    '';
  };
}
