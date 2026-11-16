{
  flake.modules.nixos.theming_targets = {lib, ...}: let
    on = names: lib.genAttrs names (_: {enable = true;});
  in {
    stylix.targets = on [
      "console"
      "font-packages"
      "fontconfig"
      "gtk"
      "lightdm"
      "nixos-icons"
      "plymouth"
    ];

    hm.stylix.targets = lib.mkMerge [
      (on [
        "bat"
        "btop"
        "cava"
        "drift"
        "eog"
        "firefox"
        "font-packages"
        "fontconfig"
        "fzf"
        "gdu"
        "gnome"
        "gtk"
        "lazygit"
        "mpv"
        "nixos-icons"
        "vivid"
        "x11"
        "yazi"
        "zathura"
      ])
      {
        cava.rainbow.enable = true;
        firefox = {
          colorTheme.enable = true;
          colors.enable = true;
          firefoxGnomeTheme.enable = false;
          fonts.enable = true;
          profileNames = ["default"];
        };
        fzf.colors.enable = true;
        vivid.colors.enable = true;
        yazi = {
          boldDirectory = true;
          colors.enable = true;
        };
      }
    ];
  };
}
