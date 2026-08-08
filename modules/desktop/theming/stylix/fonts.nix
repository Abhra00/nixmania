{
  flake.modules.nixos.theming_fonts = {
    pkgs,
    inputs,
    ...
  }: let
    inkwell = {
      sansSerif = {
        name = "Source Sans 3";
        package = pkgs.source-sans;
      };
      serif = {
        name = "Source Serif 4";
        package = pkgs.source-serif;
      };
      monospace = {
        name = "JetBrains Mono NL";
        package = pkgs.jetbrains-mono;
      };
    };
  in {
    stylix.fonts =
      inkwell
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
            <family>${inkwell.monospace.name}</family>
            <prefer>
              <family>${inkwell.monospace.name}</family>
              <family>Symbols Nerd Font Mono</family>
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
          <family>${inkwell.sansSerif.name}</family>
          <family>Noto Sans Bengali</family>
        </prefer>
        </alias>
        <alias>
        <family>serif</family>
        <prefer>
          <family>${inkwell.serif.name}</family>
          <family>Noto Serif Bengali</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
  };
}
