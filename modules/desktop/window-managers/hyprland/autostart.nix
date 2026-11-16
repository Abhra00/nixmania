{
  flake.modules.nixos.window-manager_hyprland = {
    lib,
    config,
    ...
  }: let
    hl = import ./_lib.nix {inherit lib;};
    colors = config.lib.stylix.colors;
    fontSize = toString (builtins.floor (config.stylix.fonts.sizes.popups * 1.5));
  in {
    hm.wayland.windowManager.hyprland.settings.on = [
      (hl.on "window.bell" ''
        function(w)
          local name = (w and w.title) or "terminal"
          hl.notification.create({
            text = name,
            timeout = 4000,
            icon = "info",
            color = "rgba(${colors.base0A}ff)",
            font_size = ${fontSize},
          })
        end
      '')
    ];
  };
}
