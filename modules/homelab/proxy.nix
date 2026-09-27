{ config, lib, ... }:
let
  cfg = config.homelab.proxy;
in
{
  options.homelab.proxy = {
    enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = "stefankar1000@gmail.com";
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
