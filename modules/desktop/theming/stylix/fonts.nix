{
  flake.modules.nixos.theming_fonts = {
    pkgs,
    inputs,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    typography = {
      sansSerif = {
        name = "Montserrat";
        package = pkgs.montserrat;
      };
      serif = {
        name = "Aleo";
        package = pkgs.aleo-fonts;
      };
      monospace = {
        name = "Hasklug Nerd Font";
        package = inputs.programming-fonts.packages.${system}.default;
      };
    };
  in {
    stylix.fonts =
      typography
      // {
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 12;
        };
      };
    hm.fonts.fontconfig.configFile.monospace-fallback = {
      enable = true;
      priority = 55;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>${typography.monospace.name}</family>
            <prefer>
              <family>${typography.monospace.name}</family>
              <family>Symbols Nerd Font</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
    hm.fonts.fontconfig.configFile.bengali-fallback = {
      enable = true;
      priority = 60;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
        <alias>
        <family>sans-serif</family>
        <prefer>
          <family>${typography.sansSerif.name}</family>
          <family>Noto Sans Bengali</family>
        </prefer>
        </alias>
        <alias>
        <family>serif</family>
        <prefer>
          <family>${typography.serif.name}</family>
          <family>Noto Serif Bengali</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
  };
}
