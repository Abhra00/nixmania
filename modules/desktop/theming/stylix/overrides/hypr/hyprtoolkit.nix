{
  flake.modules.nixos.window-manager_hyprland = {
    config,
    lib,
    ...
  }: let
    enabled = config.stylix.enable or false;
    stx = config.lib.stylix.colors;
    fonts = config.stylix.fonts;
    c = hex: "0xFF${hex}";
  in {
    hm.xdg.configFile."hypr/hyprtoolkit.conf" = lib.mkIf enabled {
      text = ''
        background = ${c stx.base00}
        base = ${c stx.base01}
        alternate_base = ${c stx.base02}
        text = ${c stx.base05}
        bright_text = ${c stx.base07}
        accent = ${c stx.base0D}
        accent_secondary = ${c stx.base0C}
        font_family = ${fonts.sansSerif.name}
        font_family_monospace = ${fonts.monospace.name}
      '';
    };
  };
}
