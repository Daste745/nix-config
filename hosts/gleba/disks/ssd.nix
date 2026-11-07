{
  disko.devices.disk.ssd = {
    type = "disk";
    device = "/dev/disk/by-id/ata-MTFDDAV256TBN-1AR1ZABHA_UGXVP01N4BE7UB";
    content = {
      type = "gpt";
      partitions = {
        # /data
        data = {
          label = "data";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            subvolumes = {
              "/data" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/data";
              };
            };
          };
        };
      };
    };
  };
}
