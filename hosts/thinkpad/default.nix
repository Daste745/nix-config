{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  assets = config.assets;
in
{
  system.stateVersion = "25.11";

  imports = [
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ./greetd.nix
  ];

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
    shell = pkgs.fish;
    home = "/home/stefan";
    openssh.authorizedKeys.keys = lib.attrValues assets.keys.user;
  };

  networking.hostName = "thinkpad";

  environment.systemPackages = with pkgs; [
    git
    inputs.agenix.packages.${system}.default
  ];

  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.stefan = ./home.nix;
  };

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

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "stefan"
      ];
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      # NOTE: This overwrites the default github:NixOS/templates input
      templates.flake = inputs.templates;
    };
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
  };
}
