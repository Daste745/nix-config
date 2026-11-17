{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "grafana";
  cfg = config.homelab.services.${name};
  domain = "grafana.kdng.net";
  port = config.services.grafana.settings.server.http_port;

  # Consider something like this:
  # https://github.com/alarsyo/nixos-config/blob/main/pkgs/grafana-dashboards/node-exporter.nix
  # for dashboards not available via the Grafana API

  grafanaDashboard =
    {
      id,
      rev,
      hash,
    }:
    pkgs.fetchurl {
      url = "https://grafana.com/api/dashboards/${toString id}/revisions/${toString rev}/download";
      inherit hash;
    };

  dashboards = pkgs.linkFarm "grafana-dashboards" [
    {
      name = "node-exporter-full.json";
      path = grafanaDashboard {
        id = 1860;
        rev = 46;
        hash = "sha256-5Y3cXcU11MkB+U2pZIvD49Wue2946Y4YW86LKJlhzqM=";
      };
    }
    {
      name = "victoriametrics.json";
      path = grafanaDashboard {
        id = 10229;
        rev = 61;
        hash = "sha256-k/RFtLoTBeuLhPne9UpPBQrd9a9Pg51Z5kSz+smnwxo=";
      };
    }
  ];
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
        dashboards.settings = {
          apiVersion = 1;
          providers = [
            {
              name = "nix";
              disableDeletion = true;
              allowUiUpdates = false;
              options.path = dashboards;
            }
          ];
        };
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
