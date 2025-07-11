{
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--accept-routes"
    ];
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
