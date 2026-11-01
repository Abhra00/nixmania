{
  flake.modules.nixos.theming_stylix = {config, ...}: let
    stx = config.lib.stylix.colors;
  in {
    lib.stylix.tide-palette.colors = {
      bg = {
        shared = "303030";
        git = stx.base0D;
        gitDirty = "C4A000";
        gitUrgent = "CC0000";
        statusFailure = "CC0000";
      };

      fg = {
        statusFailure = "FFFF00";
        characterFailure = "FF0000";
        direnvDenied = "FF0000";
        vcs = "000000";
      };

      separator = "949494";
      frame = "6C6C6C";

      items = {
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

      viMode = {
        default = "949494";
        insert = "87AFAF";
        replace = "87AF87";
        visual = "FF8700";
      };

      context = {
        default = "D7AF87";
        root = "D7AF00";
        ssh = "D7AF87";
      };

      pwd = {
        color_anchors = "00AFFF";
        color_dirs = "0087AF";
        color_truncated_dirs = "8787AF";
      };
    };
  };
}
