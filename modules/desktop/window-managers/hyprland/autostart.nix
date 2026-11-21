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
          hl.notification.create({
            text = w.title ~= "" and w.title or "terminal",
            timeout = 4000,
            icon = "ok",
            color = "rgb(${colors.base0D})",
            font_size = ${fontSize},
          })
        end
      '')
    ];
  };
}
