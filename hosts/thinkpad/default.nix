{ username, ... }:
{
  imports = [
    ../../modules/tailscale.nix
    ./hardware.nix
    ./disks.nix
    ./greetd.nix
  ];

  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/${username}";
  };

  home-manager.users.${username} = ./home.nix;

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.vmVariant = {
    users.users.${username}.initialPassword = "test";
    # TODO)) Load bootstrap key into the vm
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 1024 * 5;
    };
  };
}
