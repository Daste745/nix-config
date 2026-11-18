{
  config,
  lib,
  ...
}:
let
  name = "victorialogs";
  cfg = config.homelab.services.${name};
  domain = "logs.kdng.net";
in
{
  options.homelab.services.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    homelab.dashboard.services.${name} = {
      url = domain;
      title = "VictoriaLogs";
      icon = "di:victorialogs";
      description = "Log aggregation";
      category = "Observability";
    };

    services.victorialogs = {
      enable = true;
      basicAuthUsername = "admin";
      basicAuthPasswordFile = config.age.secrets.victorialogs-password.path;
      extraOptions = [
        "-retentionPeriod=30d"
      ];
    };

    systemd.services.victorialogs.unitConfig.RequiresMountFor = [
      "/var/lib/private/victorialogs"
    ];

    age.secrets.victorialogs-password = {
      file = ../../../secrets/victorialogs-password.age;
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * ${config.services.victorialogs.listenAddress}
    '';
  };
}
