{
  flake.modules.nixos.TR-100-machine = {...}: {
    preservation = {
      enable = true;
      preserveAt."/persistent" = {
        directories = [
          "/var/lib/AccountsService"
          "/var/lib/bluetooth"
          "/var/lib/libvirt"
          "/var/lib/NetworkManager"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/var/lib/noctalia-greeter"
          "/etc/NetworkManager/system-connections"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
        users.bugs = {
          directories = [
            {
              directory = ".ssh";
              mode = "0700";
            }
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
            ".config/mozilla"
            ".mozilla"
            ".config/nvim/nvim-pack-lock.json"
            ".local/share/bash"
            ".local/share/nvim"
            ".local/state/noctalia"
            ".local/state/nvim"
            "Desktop"
            "Documents"
            "Downloads"
            "Music"
            "nixmania"
            "Pictures"
            "Projects"
            "Public"
            "Templates"
            "Videos"
          ];
        };
      };
    };
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
