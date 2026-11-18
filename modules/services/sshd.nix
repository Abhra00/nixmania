{
  flake.modules.nixos.service_sshd = {config, ...}: {
    services.openssh = {
      enable = true;
      hostKeys = [
        {
          type = "ed25519";
          path = config.sops.secrets.ssh_host_ed25519_key.path;
        }
      ];
    };
  };
}
