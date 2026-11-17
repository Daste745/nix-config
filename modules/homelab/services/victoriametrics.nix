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
