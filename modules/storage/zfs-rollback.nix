{
  flake.modules.nixos.storage_zfs-rollback = {
    config,
    lib,
    pkgs,
    username,
    ...
  }: let
    cfg = config.storage.zfs;

    latestZfsKernel = let
      zfsModule = config.boot.zfs.package.kernelModuleAttribute;
      isMainline = name: builtins.match "linux_[0-9]+_[0-9]+" name != null;
      isUsable = kernel: (builtins.tryEval kernel).success && !kernel.${zfsModule}.meta.broken;
    in
      pkgs.linuxKernel.packages
      |> lib.filterAttrs (name: kernel: isMainline name && isUsable kernel)
      |> builtins.attrValues
      |> lib.sort (a: b: lib.versionOlder a.kernel.version b.kernel.version)
      |> lib.last;

    rootFsOptions = {
      acltype = "posixacl";
      atime = "off";
      compression = "zstd";
      dnodesize = "auto";
      mountpoint = "none";
      xattr = "sa";
    };

    poolOptions = {
      ashift = "12";
      autotrim = "on";
    };

    zstorageKey = "/persistent/zfs-keys/zstorage.key";

    encrypted = {
      keyformat,
      keylocation,
    }:
      rootFsOptions
      // {
        inherit keyformat keylocation;
        encryption = "aes-256-gcm";
      };
  in {
    options.storage.zfs = {
      device = lib.mkOption {
        type = lib.types.str;
        example = "/dev/disk/by-id/nvme-...";
        description = "Main disk. Holds the ESP and the zroot pool (root, nix, persistent).";
      };

      dataDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/dev/disk/by-id/ata-...";
        description = "Optional second disk. Becomes the zstorage pool, mounted at /data.";
      };

      hostId = lib.mkOption {
        type = lib.types.strMatching "[0-9a-f]{8}";
        example = "a1b2c3d4";
        description = "networking.hostId. Required, no default, so two hosts can't share one.";
      };

      espSize = lib.mkOption {
        type = lib.types.str;
        default = "2G";
      };

      arcMaxGiB = lib.mkOption {
        type = lib.types.ints.positive;
        default = 4;
        description = "Upper limit for the ZFS ARC, in GiB.";
      };
    };

    config = lib.mkMerge [
      {
        networking.hostId = cfg.hostId;

        boot = {
          # No lib.mkDefault on purpose: a leftover boot.kernelPackages in a host should collide.
          kernelPackages = latestZfsKernel;
          supportedFilesystems = ["zfs"];
          zfs.forceImportRoot = false;
          kernelParams = ["zfs.zfs_arc_max=${toString (cfg.arcMaxGiB * 1073741824)}"];
        };

        services.zfs.autoScrub = {
          enable = true;
          interval = "monthly";
        };

        fileSystems."/nix".neededForBoot = true;
        fileSystems."/persistent".neededForBoot = true;

        # Roll the root dataset back to the blank snapshot on every boot.
        # NOTE: zroot, root and @blank are hardcoded on purpose.
        boot.initrd.systemd.services.rollback = {
          description = "ZFS rollback to @blank";
          wantedBy = ["initrd.target"];

          requires = ["zfs-import-zroot.service"];
          after = ["zfs-import-zroot.service"];
          before = ["sysroot.mount"];

          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";

          path = [config.boot.zfs.package];
          script = "zfs rollback -r zroot/root@blank";
        };

        disko.devices = {
          disk.main = {
            device = cfg.device;
            type = "disk";
            content.type = "gpt";

            content.partitions.esp = {
              priority = 1;
              size = cfg.espSize;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            content.partitions.root = {
              priority = 2;
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };

          zpool.zroot = {
            type = "zpool";
            rootFsOptions = encrypted {
              keyformat = "passphrase";
              keylocation = "file:///tmp/zroot.key";
            };
            options = poolOptions;
            postCreateHook = "zfs set keylocation=prompt zroot";

            datasets.root = {
              type = "zfs_fs";
              mountpoint = "/";
              postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/root@blank$' || zfs snapshot zroot/root@blank";
            };

            datasets.nix = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };

            datasets.persistent = {
              type = "zfs_fs";
              mountpoint = "/persistent";
            };
          };
        };
      }

      (lib.mkIf (cfg.dataDevice != null) {
        disko.devices = {
          disk.data = {
            device = cfg.dataDevice;
            type = "disk";
            content.type = "gpt";

            content.partitions.data = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zstorage";
              };
            };
          };

          # Separate pool: root rollback never touches it.
          zpool.zstorage = {
            type = "zpool";
            rootFsOptions = encrypted {
              keyformat = "raw";
              keylocation = "file:///tmp/zstorage.key";
            };
            options = poolOptions;
            postCreateHook = "zfs set keylocation=file://${zstorageKey} zstorage";

            datasets.data = {
              type = "zfs_fs";
              mountpoint = "/data";
            };
          };
        };

        systemd.tmpfiles.rules = ["d /data 0755 ${username} users - -"];
      })
    ];
  };
}
