{
  flake.modules.nixos.service_gpg = {pkgs, ...}: {
    hm.programs.gpg = {
      enable = true;
      settings = {
        keyserver = "hkps://keys.openpgp.org";
        keyserver-options = "auto-key-retrieve";
      };
    };

    hm.services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
      defaultCacheTtl = 34560;
      maxCacheTtl = 34560;
    };
  };
}
