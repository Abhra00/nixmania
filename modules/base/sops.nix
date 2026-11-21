{
  flake.modules.nixos.base = {
    config,
    lib,
    pkgs,
    username,
    ...
  }: let
    # Only main user can read the secrets
    userSecret = {
      owner = username;
      mode = "0400";
    };
  in {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      age.keyFile = "/persistent/var/lib/sops-nix/key.txt";
      age.plugins = lib.optional config.security.tpm2.enable pkgs.age-plugin-tpm;

      secrets = {
        gh_token = userSecret;
        gpg_private_key = userSecret;
        ssh_private_key = userSecret;
        ssh_host_ed25519_key = {};
        google_ical_url = userSecret;
      };
    };
  };
}
