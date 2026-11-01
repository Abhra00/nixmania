# Home Manager module: programs.drift
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption mkPackageOption types;

  cfg = config.programs.drift;
  tomlFormat = pkgs.formats.toml {};

  themeModule = types.submodule {
    options = {
      bright = mkOption {
        type = types.str;
        example = "#e8e8e8";
        description = "Highlight color, as #RRGGBB.";
      };
      palette = mkOption {
        type = types.nonEmptyListOf types.str;
        example = ["#ff6b6b" "#4ecdc4" "#45b7d1"];
        description = "Main scene colors, as #RRGGBB.";
      };
      dim = mkOption {
        type = types.nonEmptyListOf types.str;
        example = ["#3d1010" "#0e2e2c" "#0e2530"];
        description = ''
          Dim counterparts of `palette`, as #RRGGBB.
          Must have the same length as `palette` (drift validates this).
        '';
      };
    };
  };

  settings =
    cfg.settings
    // lib.optionalAttrs (cfg.themes != {}) {theme = cfg.themes;};
in {
  options.programs.drift = {
    enable = mkEnableOption "drift, a terminal screensaver";

    package = mkPackageOption pkgs "drift" {};

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
      example = lib.literalExpression ''
        {
          engine = {
            fps = 30;
            cycle_seconds = 60;
            scenes = "all";
            theme = "nord";
          };
          scene.rain.density = 0.4;
        }
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/drift/config.toml`.
        See <https://github.com/phlx0/drift#configuration>.
      '';
    };

    themes = mkOption {
      type = types.attrsOf themeModule;
      default = {};
      description = ''
        Custom themes, written under `[theme.<name>]`. Select one with
        `settings.engine.theme`. A theme named like a built-in overrides it.
      '';
    };

    idleTimeout = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      example = 300;
      description = ''
        Seconds of shell inactivity before drift starts, exported as
        `DRIFT_TIMEOUT`. When null, drift's default (120) applies.
      '';
    };

    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption {inherit config;};
    enableFishIntegration = lib.hm.shell.mkFishIntegrationOption {inherit config;};
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption {inherit config;};
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."drift/config.toml" = mkIf (settings != {}) {
      source = tomlFormat.generate "drift-config.toml" settings;
    };

    home.sessionVariables = mkIf (cfg.idleTimeout != null) {
      DRIFT_TIMEOUT = toString cfg.idleTimeout;
    };

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      eval "$(${lib.getExe cfg.package} shell-init bash)"
    '';

    programs.zsh.initContent = mkIf cfg.enableZshIntegration ''
      eval "$(${lib.getExe cfg.package} shell-init zsh)"
    '';

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
      ${lib.getExe cfg.package} shell-init fish | source
    '';
  };
}
