{
  flake.modules.nixos.theming_fonts = {pkgs, ...}: let
    fontSets = {
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
          name = "Source Code Pro";
          package = pkgs.source-code-pro;
        };
      };
    };
  in {
    stylix.fonts =
      fontSets.adobe
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
            <family>${fontSets.adobe.monospace.name}</family>
            <prefer>
              <family>${fontSets.adobe.monospace.name}</family>
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
          <family>${fontSets.adobe.sansSerif.name}</family>
          <family>Noto Sans Bengali</family>
        </prefer>
        </alias>
        <alias>
        <family>serif</family>
        <prefer>
          <family>${fontSets.adobe.serif.name}</family>
          <family>Noto Serif Bengali</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
  };
}
