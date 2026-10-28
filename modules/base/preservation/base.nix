{
  flake.modules.nixos.base = {username, ...}: {
    preservation = {
      enable = true;
      preserveAt."/persistent" = {
        commonMountOptions = ["x-gvfs-trash" "x-gvfs-hide"];

        directories = [
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          {
            directory = "/var/lib/sops-nix";
            inInitrd = true;
            mode = "0700";
          }
          "/var/lib/iwd"
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/var/lib/systemd/credential.secret";
            inInitrd = true;
            mode = "0400";
          }
        ];

        users.${username}.directories = [
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
          ".local/share/devtools"
        ];
      };
    };

    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
    systemd.tmpfiles.rules = ["d /nix/var/nix/builds 0755 root root - -"];
  };
}
