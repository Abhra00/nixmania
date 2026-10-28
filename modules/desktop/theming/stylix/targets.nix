{
  flake.modules.nixos.theming_targets = {
    stylix.targets = {
      fontconfig.enable = true;
      fish.enable = false;
    };

    hm.stylix.targets = {
      cava = {
        rainbow.enable = true;
      };
      fontconfig.enable = true;
      firefox = {
        enable = true;
        colorTheme.enable = true;
        colors.enable = true;
        firefoxGnomeTheme.enable = false;
        fonts.enable = true;
        profileNames = ["default"];
      };
      fzf = {
        enable = true;
        colors.enable = true;
      };
      vivid = {
        enable = true;
        colors.enable = true;
      };
      yazi = {
        enable = true;
        boldDirectory = true;
        colors.enable = true;
      };
      fish.enable = false;
      ghostty.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      hyprpaper.enable = false;
      neovim.enable = false;
      noctalia.enable = false;
      rofi.enable = false;
      tmux.enable = false;
    };
  };
}
