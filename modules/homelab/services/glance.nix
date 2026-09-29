{ config, lib, ... }:
let
  name = "glance";
  cfg = config.homelab.services.${name};
  domain = "kdng.net";

  services = lib.attrValues config.homelab.dashboard.services;
  # TODO)) Declare order of categories
  servicesByCategory = lib.groupBy (service: service.category) services;
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
