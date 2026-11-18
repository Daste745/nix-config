{
  config,
  lib,
  ...
}:
let
  name = "victoriametrics";
  cfg = config.homelab.services.${name};
  domain = "metrics.kdng.net";
in
{
  options.homelab.services.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    homelab.dashboard.services.${name} = {
      url = domain;
      title = "VictoriaMetrics";
      icon = "di:victoriametrics";
      description = "Time series database";
      category = "Observability";
    };

    services.victoriametrics = {
      enable = true;
      basicAuthUsername = "admin";
      basicAuthPasswordFile = config.age.secrets.victoriametrics-password.path;
      retentionPeriod = "1"; # 1 month
      prometheusConfig = {
        global = {
          scrape_interval = "30s";
        };
        scrape_configs = [
          {
            job_name = "node";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
                labels = {
                  # TODO)) Is `type` needed? All targets have the same `job` label anyway
                  type = "node";
                  instance = "gleba";
                };
              }
            ];
          }
          {
            job_name = "victoriametrics";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = [ "127.0.0.1:8428" ];
                labels = {
                  type = "victoriametrics";
                  instance = "gleba";
                };
              }
            ];
            basic_auth = {
              username = config.services.victoriametrics.basicAuthUsername;
              password_file = "/run/credentials/victoriametrics.service/basic_auth_password";
            };
            metric_relabel_configs = [
              # HACK: The VictoriaMetrics Grafana dashboard expects `version` labels to be prefixed with `victoria-metrics-`
              {
                source_labels = [
                  "__name__"
                  "version"
                ];
                regex = "vm_app_version;(.*)";
                target_label = "version";
                replacement = "victoria-metrics-$1";
              }
            ];
          }
          {
            job_name = "victorialogs";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = [ "127.0.0.1:9428" ];
                labels = {
                  type = "victorialogs";
                  instance = "gleba";
                };
              }
            ];
            metric_relabel_configs = [
              # HACK: The VictoriaLogs Grafana dashboard expects `version` labels to be prefixed with `victoria-logs-`
              {
                source_labels = [
                  "__name__"
                  "version"
                ];
                regex = "vm_app_version;(.*)";
                target_label = "version";
                replacement = "victoria-logs-$1";
              }
            ];
          }
        ];
      };
    };

    # TODO)) Move to a separate module when needed on more hosts
    services.prometheus.exporters.node = {
      enable = true;
      listenAddress = "127.0.0.1";
      enabledCollectors = [ "systemd" ];
    };

    systemd.services.victoriametrics.unitConfig.RequiresMountFor = [
      "/var/lib/private/victoriametrics"
    ];

    age.secrets.victoriametrics-password = {
      file = ../../../secrets/victoriametrics-password.age;
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * ${config.services.victoriametrics.listenAddress}
    '';
  };
}
