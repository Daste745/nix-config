{ config, lib, ... }:
let
  name = "grafana";
  cfg = config.homelab.services.${name};
  domain = "grafana.kdng.net";
  port = config.services.grafana.settings.server.http_port;
in
{
  options.homelab.services.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    homelab.dashboard.services.${name} = {
      url = domain;
      title = "Grafana";
      description = "Monitoring dashboard";
      category = "Services";
    };

    services.grafana = {
      enable = true;
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * localhost:${toString port}
    '';
  };
}
