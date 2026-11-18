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
      listenAddress = "127.0.0.1:9428";
      # TODO)) Setup auth via caddy
      extraOptions = [
        "-retentionPeriod=30d"
      ];
    };

    services.journald.upload = {
      enable = true;
      settings.Upload.URL = "http://127.0.0.1:9428/insert/journald";
    };

    systemd.services.victorialogs.unitConfig.RequiresMountFor = [
      "/var/lib/private/victorialogs"
    ];

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * ${config.services.victorialogs.listenAddress}
    '';
  };
}
