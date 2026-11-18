{ lib, username, ... }: {
  imports = [
    ../../modules/homelab
    ../../modules/tailscale.nix
    ./hardware.nix
    ./disks
  ];

  system.stateVersion = "26.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    home = "/home/${username}";
  };

  services.tailscale = {
    useRoutingFeatures = "both";
    extraUpFlags = lib.mkForce [
      "--accept-routes"
      "--advertise-exit-node"
      "--advertise-routes=192.168.1.110/32"
    ];
  };

  homelab.proxy.enable = true;
  homelab.services = {
    whoami.enable = true;
    glance.enable = true;
    grafana.enable = true;
    victorialogs.enable = true;
    victoriametrics.enable = true;
  };

  home-manager.users.${username} = ./home.nix;
}
