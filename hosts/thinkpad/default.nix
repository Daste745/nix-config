{
  imports = [
    ../../modules/tailscale.nix
    ./greetd.nix
  ];

  system.stateVersion = "25.11";

  networking.hostName = "thinkpad";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # TODO)) Disk partitioning with disko + encryption (luks?)

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/stefan";
  };

  home-manager.users.stefan = ./home.nix;

  virtualisation.docker.enable = true;

  virtualisation.vmVariant = {
    users.users.stefan.initialPassword = "test";
    # TODO)) Load bootstrap key into the vm
    virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 1024 * 5;
    };
  };
}
