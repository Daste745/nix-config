{ config, lib, ... }:
let
  name = "immich";
  cfg = config.homelab.services.${name};
  domain = "photos.kdng.net";
in
{
  options.homelab.services.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    homelab.dashboard.services.${name} = {
      url = domain;
      title = "Immich";
      description = "Photo library";
      category = "Media";
      icon = "di:immich";
    };

    services.immich = {
      enable = true;
      # TODO)) accelerationDevices = [ "/dev/dri/renderD128" ];
      # TODO)) mediaLocation = "/data/immich";
      settings.server.externalDomain = "https://${domain}";
    };

    users.users.${config.services.immich.user}.extraGroups = [
      "video"
      "render"
    ];

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * localhost:${toString config.services.immich.port}
    '';
  };
}
