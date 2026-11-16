{
  flake.modules.nixos.base = {
    lib,
    username,
    ...
  }: let
    initrd = map (entry: entry // {inInitrd = true;});
    alias = from: to:
      lib.mkAliasOptionModule from (["preservation" "preserveAt" "/persistent"] ++ to);
  in {
    imports = lib.concatMap (kind: [
      (alias ["persist" kind] [kind])
      (alias ["persist" "user" kind] ["users" username kind])
    ]) ["directories" "files"];

    preservation = {
      enable = true;
      preserveAt."/persistent".commonMountOptions = ["x-gvfs-trash" "x-gvfs-hide"];
    };

    persist = {
      directories =
        initrd [
          {directory = "/var/lib/nixos";}
          {
            directory = "/var/lib/sops-nix";
            mode = "0700";
          }
        ]
        ++ [
          {
            directory = "/var/log/journal";
            group = "systemd-journal";
            mode = "2755";
            user = "root";
          }
          "/var/lib/iwd"
          "/var/lib/systemd"
        ];

      files = initrd [{file = "/etc/machine-id";}];

      user.directories = [
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

    systemd = {
      suppressedSystemUnits = ["systemd-machine-id-commit.service"];
      tmpfiles.rules = ["d /nix/var/nix/builds 0755 root root - -"];
    };
  };
}
