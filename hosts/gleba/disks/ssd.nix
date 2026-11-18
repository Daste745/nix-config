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
                mountpoint = "/data";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/data/victorialogs" = {
                mountpoint = "/var/lib/private/victorialogs";
                mountOptions = [
                  "noatime"
                ];
              };
              "/data/victoriametrics" = {
                mountpoint = "/var/lib/private/victoriametrics";
                mountOptions = [
                  "noatime"
                ];
              };
              "/data/grafana" = {
                mountpoint = "/var/lib/grafana";
                mountOptions = [
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
