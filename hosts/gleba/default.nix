{ username, ... }: {
  imports = [
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

  home-manager.users.${username} = ./home.nix;

  nix.settings = {
    # TODO)) Move to hosts/common.nix once enabled on all hosts
    use-xdg-base-directories = true;
  };
}
