{
  flake.modules.nixos.TR-100-machine = {...}: {
    preservation = {
      enable = true;
      preserveAt."/persistent" = {
        directories = [
          "/var/lib/bluetooth"
          "/var/lib/libvirt"
          "/var/lib/postgresql"
          "/var/lib/NetworkManager"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
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
            ".config/mozilla"
            ".config/obs-studio"
            ".mozilla"
            ".local/state/noctalia"
            ".local/share/bash"
            ".rustup"
            "nixmania"
            "Projects"
            "Pictures"
            "Music"
            "Videos"
          ];
        };
      };
    };
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
