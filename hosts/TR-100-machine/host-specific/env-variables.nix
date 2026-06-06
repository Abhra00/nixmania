{
  flake.modules.nixos.TR-100-machine = {
    hm.home.sessionVariables = {
      TERMINAL = "ghostty";
      BROWSER = "firefox-devedition";
      EDITOR = "hx";
      VISUAL = "hx";
      SUDO_EDITOR = "vim";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
