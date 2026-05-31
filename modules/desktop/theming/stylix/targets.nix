{
  flake.modules.nixos.theming_targets = {
    stylix.targets = {
      fontconfig.enable = true;
    };

    hm.stylix.targets = {
      tmux.enable = false;
      helix.enable = false;
      foot.enable = false;
      noctalia-shell.enable = false;
      fontconfig.enable = true;
      firefox = {
        colorTheme.enable = true;
        colors.enable = true;
        fonts.enable = true;
        profileNames = ["dev-edition-default"];
      };
      cava = {
        rainbow.enable = true;
      };
      gtk.extraCss = ''
        window.dialog decoration,
        window.dialog {
          border-radius: 0;
          box-shadow: none;
        }
      '';
    };
  };
}
