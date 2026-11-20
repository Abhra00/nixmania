{
  flake.modules.nixos.service_sshd = {config, ...}: {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          type = "ed25519";
          path = config.sops.secrets.ssh_host_ed25519_key.path;
        }
      ];
    };
  };
}
