{
  flake.modules.nixos.security_secureboot = {
    inputs,
    lib,
    pkgs,
    ...
  }: let
    keyFiles = {
      sb_GUID = "GUID";
      sb_PK_key = "keys/PK/PK.key";
      sb_PK_pem = "keys/PK/PK.pem";
      sb_KEK_key = "keys/KEK/KEK.key";
      sb_KEK_pem = "keys/KEK/KEK.pem";
      sb_db_key = "keys/db/db.key";
      sb_db_pem = "keys/db/db.pem";
    };
  in {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];
    environment.systemPackages = [pkgs.sbctl];

    sops.secrets =
      lib.mapAttrs (_: file: {
        path = "/var/lib/sbctl/${file}";
        owner = "root";
        mode = "0400";
      })
      keyFiles;
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
