{
  config,
  lib,
  username,
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
      basicAuthUsername = username;
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
