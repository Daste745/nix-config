{ config, lib, ... }:
let
  name = "glance";
  cfg = config.homelab.services.${name};
  domain = "kdng.net";

  services = lib.attrValues config.homelab.dashboard.services;
  extraServices = [
    {
      title = "Nextcloud";
      icon = "di:nextcloud";
      url = "cloud.kdng.net";
      # TODO)) alt-status-codes: [ 400 ]
      category = "Services";
    }
    {
      title = "Syncthing";
      icon = "di:syncthing";
      url = "syncthing.kdng.net";
      category = "Services";
    }
    {
      title = "Home Assistant";
      icon = "di:home-assistant";
      url = "homeassistant.kdng.net";
      # check-url: https://homeassistant.kdng.net  # port 80 doesn't respond
      category = "Services";
    }
    {
      title = "Transmission";
      icon = "di:transmission";
      url = "transmission.kdng.net";
      category = "Services";
    }
    {
      title = "Paperless";
      icon = "di:paperless-ngx";
      url = "paperless.kdng.net";
      category = "Services";
    }
    {
      title = "TrueNAS";
      icon = "di:truenas";
      url = "192.168.1.100:81";
      category = "Management";
    }
    {
      title = "Nginx Proxy Manager";
      icon = "di:nginx-proxy-manager";
      url = "npm.kdng.net";
      category = "Management";
    }
    {
      title = "Authelia";
      icon = "di:authelia";
      url = "auth.kdng.net";
      category = "Management";
    }
    {
      title = "JetKVM";
      icon = "di:jetkvm";
      # TODO)) http, not https
      url = "jetkvm.kdng.net";
      # allow-insecure = true;
      category = "Management";
    }
    {
      title = "Router";
      icon = "di:unifi";
      # TODO)) http, not https
      url = "192.168.1.1";
      # allow-insecure = true;
      category = "Management";
    }
    {
      title = "Immich";
      icon = "di:immich";
      url = "photos.kdng.net";
      category = "Media";
    }
    {
      title = "Jellyfin";
      icon = "di:jellyfin";
      url = "jellyfin.kdng.net";
      category = "Media";
    }
    {
      title = "Kavita";
      icon = "di:kavita";
      url = "kavita.kdng.net";
      category = "Media";
    }
    {
      title = "slskd";
      icon = "di:slskd";
      url = "slskd.kdng.net";
      category = "Media";
    }
    {
      title = "Prowlarr";
      icon = "di:prowlarr";
      url = "prowlarr.kdng.net";
      category = "Media";
    }
    {
      title = "MeTube";
      icon = "di:metube";
      url = "metube.kdng.net";
      category = "Media";
    }
  ];
  # TODO)) Declare order of categories
  servicesByCategory = lib.groupBy (service: service.category) (services ++ extraServices);
  # Create a monitor site entry
  monitorSite =
    cfg:
    let
      url = "https://${cfg.url}";
    in
    {
      inherit (cfg) title icon;
      inherit url;
      check-url = url;
    };
  # Map all service dashboard configs to `monitor` widgets, grouped by category
  serviceMonitors = lib.mapAttrsToList (category: services: {
    type = "monitor";
    cache = "1m";
    title = category;
    sites = lib.map monitorSite services;
  }) servicesByCategory;
in
{
  options.homelab.services.glance = {
    enable = lib.mkEnableOption "glance";
  };

  config = lib.mkIf cfg.enable {
    services.glance = {
      enable = true;
      # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#branding
      settings.branding = {
        logo-text = "kdng";
      };
      # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#theme
      settings.theme = {
        background-color = "240 21 15";
        contrast-multiplier = 1.2;
        primary-color = "217 92 83";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };
      # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#pages--columns
      settings.pages = [
        {
          name = "Home";
          columns = [
            # Left sidebar
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  hide-header = true;
                  first-day-of-week = "monday";
                }
                {
                  type = "weather";
                  hide-header = true;
                  units = "metric";
                  hour-format = "24h";
                  location = "Gdansk, Poland";
                  hide-location = false;
                }
                {
                  type = "server-stats";
                  hide-header = true;
                  servers = [
                    {
                      type = "local";
                    }
                  ];
                }
              ];
            }
            # Center
            {
              size = "full";
              widgets = serviceMonitors;
            }
          ];
        }
      ];
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * localhost:${toString config.services.glance.settings.server.port}
    '';
  };
}
