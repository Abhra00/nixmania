{
  flake.modules.nixos.theming_fonts = {
    pkgs,
    inputs,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    adobe = {
      sansSerif = {
        name = "Source Sans 3";
        package = pkgs.source-sans;
      };
      serif = {
        name = "Source Serif 4";
        package = pkgs.source-serif;
      };
      monospace = {
        name = "Hasklug Nerd Font";
        package = inputs.programming-fonts.packages.${system}.default;
      };
    };
  in {
    stylix.fonts =
      adobe
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
            <family>${adobe.monospace.name}</family>
            <prefer>
              <family>${adobe.monospace.name}</family>
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
          <family>${adobe.sansSerif.name}</family>
          <family>Noto Sans Bengali</family>
        </prefer>
        </alias>
        <alias>
        <family>serif</family>
        <prefer>
          <family>${adobe.serif.name}</family>
          <family>Noto Serif Bengali</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
  };
}
