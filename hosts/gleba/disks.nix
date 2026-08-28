{
  # TODO)) disk partitioning. btrfs root?
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/mmcblk0";
    content = {
      type = "gpt";
      partitions = {
        # /boot
        ESP = {
          priority = 1;
          type = "EF00";
          label = "boot";
          start = "1M";
          end = "128M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        # /
        root = {
          label = "root";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            subvolumes = {
              "/root" = {
                mountpoint = "/";
              };
              "/nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
  };
}
