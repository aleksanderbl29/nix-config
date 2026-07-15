{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-RS512GSSD510_EC071205A000076";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      stor1 = {
        # Replace this with the actual /dev/disk/by-id path before deployment.
        device = "/dev/disk/by-id/REPLACE_WITH_STORAGE_DISK_1";
        type = "disk";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "storage";
            };
          };
        };
      };
      stor2 = {
        # Replace this with the actual /dev/disk/by-id path before deployment.
        device = "/dev/disk/by-id/REPLACE_WITH_STORAGE_DISK_2";
        type = "disk";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "storage";
            };
          };
        };
      };
      stor3 = {
        # Replace this with the actual /dev/disk/by-id path before deployment.
        device = "/dev/disk/by-id/REPLACE_WITH_STORAGE_DISK_3";
        type = "disk";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "storage";
            };
          };
        };
      };
    };
    zpool = {
      storage = {
        type = "zpool";
        mode = "raidz1";
        mountpoint = "none";

        datasets.private = {
          type = "zfs_fs";
          mountpoint = "/mnt/private";
        };
        datasets.media = {
          type = "zfs_fs";
          mountpoint = "/mnt/media";
        };
      };
    };
  };
}
