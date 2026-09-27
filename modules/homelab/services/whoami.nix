{ config, lib, ... }:
let
  name = "whoami";
  cfg = config.homelab.services.${name};
  domain = "whoami.kdng.net";
in
{
  options.homelab.services.${name} = {
    enable = lib.mkEnableOption name;
  };

  config = lib.mkIf cfg.enable {
    homelab.dashboard.services.${name} = {
      url = domain;
      title = "Whoami";
      description = "HTTP request tester";
      category = "Services";
    };

    services.whoami = {
      enable = true;
    };

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      reverse_proxy * localhost:${toString config.services.whoami.port}
    '';
  };
}
