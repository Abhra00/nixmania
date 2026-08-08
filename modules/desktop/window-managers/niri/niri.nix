{inputs, ...}: {
  flake.modules.nixos.window-manager_niri = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.niri-flake.nixosModules.niri];
    nixpkgs.overlays = [inputs.niri-flake.overlays.niri];

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = "gtk gnome";
          "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
        };
        niri.default = lib.mkForce [
          "gnome"
          "gtk"
          "wlr"
        ];
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    systemd.user.services.xdg-desktop-portal.after = ["niri.service"];
    systemd.user.services.xdg-desktop-portal-gnome.after = ["niri.service"];

    hm.home.packages = with pkgs; [xwayland-satellite];
  };
}
