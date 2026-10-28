{
  flake.modules.nixos.service_gpg = {
    config,
    pkgs,
    ...
  }: let
    gpg = config.hm.programs.gpg.package;
  in {
    hm.programs.gpg = {
      enable = true;
      settings = {
        keyserver = "hkps://keys.openpgp.org";
        keyserver-options = "auto-key-retrieve";
      };
      publicKeys = [
        {
          source = ../../secrets/pubkeys/gpg.asc;
          trust = "ultimate";
        }
      ];
    };

    hm.services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
      defaultCacheTtl = 34560;
      maxCacheTtl = 34560;
    };

    systemd.user.services.gpg-import-key = {
      description = "Import GPG private key from sops";
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${gpg}/bin/gpg --batch --import ${config.sops.secrets.gpg_private_key.path}
      '';
    };
  };
}
