{
  flake.modules.nixos.TR-100-machine = {
    hm.home.sessionVariables = {
      TERMINAL = "ghostty";
      BROWSER = "firefox";
      EDITOR = "hx";
      VISUAL = "hx";
      SUDO_EDITOR = "vim";
      SUDO_PROMPT = builtins.fromJSON ''
        "\u001b[1;31m[\u001b[1;33m%p\u001b[1;31m] \u001b[1;32mEnter \u001b[1;34mSudo \u001b[1;35mPassword \u001b[1;31m \u001b[0m: "
      '';
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
