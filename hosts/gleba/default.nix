{ username, ... }: {
  imports = [
    ../../modules/homelab
    ../../modules/tailscale.nix
    ./hardware.nix
    ./disks.nix
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

  homelab.proxy.enable = true;
  homelab.services = {
    whoami.enable = true;
    glance.enable = true;
  };

  home-manager.users.${username} = ./home.nix;
}
