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
      # stor1 = {
      #   device = "/dev/....";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "storage";
      #         };
      #       };
      #     };
      #   };
      # };
      # stor2 = {
      #   device = "/dev/....";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "storage";
      #         };
      #       };
      #     };
      #   };
      # };
      # stor3 = {
      #   device = "/dev/....";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "storage";
      #         };
      #         };
      #       };
      #     };
      #   };
      # };
      # zpool = {
      #   storage = {
      #     type = "zpool";
      #     mode = "raidz1";
      #     mountpoint = "/storage";

      #     datasets = {
      #       dataset = {
      #         type = "zfs_fs";
      #         mountpoint = "/storage/dataset";
      #       };
      #     };
      #   };
    };
  };
}
