{ username, ... }: {
  imports = [
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

  # TODO)) Check how much space home-manager will eat
  # home-manager.users.${username} = ./home;

  # TODO)) nix-ld needed?
  # programs.nix-ld.enable = true;

  # TODO)) Maybe podman? Or something else?
  # virtualisation.docker.enable = true;

  nix.settings = {
    # TODO)) Move to hosts/common.nix once enabled on all hosts
    use-xdg-base-directories = true;
  };
}
