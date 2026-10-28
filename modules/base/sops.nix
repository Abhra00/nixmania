{
  flake.modules.nixos.base = {username, ...}: let
    # Only main user can read the secrets
    userSecret = {
      owner = username;
      mode = "0400";
    };
  in {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      age.keyFile = "/persistent/var/lib/sops-nix/key.txt";

      secrets = {
        gh_token = userSecret;
        gpg_private_key = userSecret;
        ssh_private_key = userSecret;
        google_ical_url = userSecret;
      };
    };
  };
}
