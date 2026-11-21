{
  flake.modules.nixos.base = {...}: {
    security.sudo = {
      enable = true;
      extraConfig = ''
        Defaults passwd_timeout=0
        Defaults timestamp_timeout=15
      '';
    };
  };
}
