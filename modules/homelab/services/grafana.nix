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
      icon = "di:grafana";
      description = "Monitoring dashboard";
      category = "Observability";
    };

    services.grafana = {
      enable = true;
      settings = {
        security = {
          admin_user = "admin";
          admin_password = "$__file{${config.age.secrets.grafana-admin-password.path}}";
          secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
        };
      };
      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "VictoriaMetrics";
              uid = "victoriametrics";
              type = "prometheus";
              url = "http://127.0.0.1:8428";
              isDefault = true;
              basicAuth = true;
              basicAuthUser = config.services.victoriametrics.basicAuthUsername;
              secureJsonData = {
                basicAuthPassword = "$__file{${config.age.secrets.victoriametrics-password-grafana.path}}";
              };
            }
          ];
        };
        # TODO)) dashboards.settings
      };
    };

    systemd.services.grafana.unitConfig.RequiresMountFor = [
      "/var/lib/grafana"
    ];

    age.secrets = {
      grafana-admin-password = {
        file = ../../../secrets/grafana-admin-password.age;
        owner = "grafana";
      };
      grafana-secret-key = {
        file = ../../../secrets/grafana-secret-key.age;
        owner = "grafana";
      };
      victoriametrics-password-grafana = {
        file = ../../../secrets/victoriametrics-password.age;
        owner = "grafana";
      };
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * localhost:${toString port}
    '';
  };
}
