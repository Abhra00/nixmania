{
  flake.modules.nixos.cli_drift = {
    hm = {
      imports = [
        ./_module.nix
        ./_stylix.nix
      ];

      programs.drift = {
        enable = true;
        idleTimeout = 300;
        settings.engine = {
          fps = 30;
          cycle_seconds = 60;
          scenes = "all";
        };
        # Intentionally disable shell integration
        enableBashIntegration = false;
        enableFishIntegration = false;
        enableZshIntegration = false;
      };
    };
  };
}
