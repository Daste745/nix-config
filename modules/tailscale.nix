{ config, ... }: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--accept-routes"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
