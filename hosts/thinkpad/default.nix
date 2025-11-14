{ username, pkgs, ... }:
{
  imports = [
    ../../modules/tailscale.nix
    ./hardware.nix
    ./disks.nix
    ./greetd.nix
    ./xdg.nix
  ];

  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  # TODO)) Remove this once feishin uses electron >= 37.0.0
  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/${username}";
  };

  fonts.packages = with pkgs; [
    maple-mono.truetype
    maple-mono.NF
    font-awesome
    material-design-icons
    nerd-fonts.symbols-only
  ];

  i18n.extraLocales = [ "pl_PL.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  home-manager.users.${username} = ./home;

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

  nix.settings = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
