{
  flake.modules.nixos.theming_fonts = {pkgs, ...}: let
    fontSets = {
      source = {
        sansSerif = {
          name = "Rubik";
          package = pkgs.rubik;
        };
        serif = {
          name = "Fraunces";
          package = pkgs.fraunces;
        };
        monospace = {
          name = "Fira Code";
          package = pkgs.fira-code;
        };
      };
    };
  in {
    stylix.fonts =
      fontSets.source
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
            <family>${fontSets.source.monospace.name}</family>
            <prefer>
              <family>${fontSets.source.monospace.name}</family>
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
          <family>${fontSets.source.sansSerif.name}</family>
          <family>Noto Sans Bengali</family>
        </prefer>
        </alias>
        <alias>
        <family>serif</family>
        <prefer>
          <family>${fontSets.source.sansSerif.name}</family>
          <family>Noto Serif Bengali</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
  };
}
