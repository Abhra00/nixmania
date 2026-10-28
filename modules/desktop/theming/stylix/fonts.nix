{
  flake.modules.nixos.theming_fonts = {pkgs, ...}: let
    inkwell = {
      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      serif = {
        name = "Lora";
        package = pkgs.lora;
      };
      monospace = {
        name = "PlemolJP Console";
        package = pkgs.plemoljp;
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

    # PlemolJP Console has two glyph widths (528/1056), so fontconfig scans it
    # as spacing=dual. Ghostty always requests spacing=mono, and fontconfig
    # ranks spacing above weight and style, so Bold outranked Regular.
    # Rewriting the request to dual at lookup time fixes the ranking without
    # touching the font or the font cache.
    hm.fonts.fontconfig.configFile.monospace-spacing = {
      enable = true;
      priority = 55;
      text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test name="family"><string>${inkwell.monospace.name}</string></test>
            <edit name="spacing" mode="assign"><const>dual</const></edit>
          </match>
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
