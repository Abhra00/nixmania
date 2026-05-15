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
            ".mozilla"
            ".config/noctalia"
            ".local/share/bash"
            ".cache/noctalia"
            ".cache/noctalia-qs"
            "nixmania"
            "Projects"
            "Pictures"
            "Videos"
          ];
        };
      };
    };
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  };
}
