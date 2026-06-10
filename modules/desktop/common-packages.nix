{
  flake.modules.nixos.desktop_common-packages = {pkgs, ...}: {
    hm.home.packages = with pkgs; [
      brightnessctl
      cliphist
      playerctl
      wl-clip-persist
      wl-clipboard
      wtype
    ];
  };
}
