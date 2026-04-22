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
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };

  # Linux 6.18.23 panics before /boot can be mounted, logs from boot:
  #
  # No filesystem could mount root, tried:
  # Kernel panic - not syncing: VFS: Unable to mount root fs on "fstab" or unknown-block(0,0)
  boot.kernelPackages = pkgs.linuxPackagesFor (
    pkgs.linux_6_18.override {
      argsOverride = rec {
        version = "6.18.22";
        modDirVersion = version;
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-ojyS+vNlc4XCxrX07dj4G4CJB+vmA/owaZ6uIk2lX1k=";
        };
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
    download-buffer-size = 1024 * 1024 * 1024; # 1 GiB
    # TODO)) Move to hosts/common.nix once enabled on all hosts
    use-xdg-base-directories = true;
  };
}
