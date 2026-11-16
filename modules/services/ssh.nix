{
  flake.modules.nixos.service_ssh = {config, ...}: {
    hm.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        IdentityFile = config.sops.secrets.ssh_private_key.path;
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
      };
    };

    hm.services.ssh-agent.enable = true;
    services.gnome.gcr-ssh-agent.enable = false;
  };
}
