{
  config,
  lib,
  pkgs,
  ...
}:
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
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
        hash = "sha256-QSiwKqKvSxhksWBF4/MlBOpyXba5xOQ2sRwA0R7399E=";
      };
      environmentFile = config.age.secrets.caddy-env.path;
      globalConfig = ''
        metrics {
          per_host
        }
        cert_issuer acme {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          resolvers 1.1.1.1 1.0.0.1
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    age.secrets.caddy-env = {
      file = ../../secrets/caddy-env.age;
    };
  };
}
