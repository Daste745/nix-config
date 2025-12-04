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

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackagesFor (
    # The latest upgrade to nixos 26.05 also upgraded the kernel to 6.12.59, which is panicking on boot
    # The panic on 6.12.59 doesn't happen in a VM, only on baremetal
    # Overriding the version to 6.12.58 makes it work on baremetal again
    # This makes me think it's some hardware issue, but I'm not sure
    # TODO)) Find out why this is even an issue and remove this override once it's fixed
    pkgs.linux_6_12.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-XxxMVGZgpqgQRv36YZUwa60sjRfA1ph23BAKha1GE6w=";
        };
        version = "6.12.58";
        modDirVersion = "6.12.58";
      };
    }
  );

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
