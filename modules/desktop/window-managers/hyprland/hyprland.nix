{
  flake.modules.nixos.window-manager_hyprland = {
    inputs,
    pkgs,
    ...
  }: let
    hyprPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.hyprland = {
      enable = true;
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}
