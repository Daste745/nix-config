{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ../../modules/ssh.nix
  ];

  users.users.stefan = {
    shell = pkgs.fish;
    home = "/Users/stefan";
    openssh.authorizedKeys.keys = lib.attrValues (import ../../assets/ssh.nix).users;
  };

  networking.hostName = "aquilo";

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    git
    inputs.agenix.packages.${system}.default
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.stefan = ./home.nix;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
    ];

  system = {
    primaryUser = "stefan";
    startup.chime = false;
    defaults = {
      dock = {
        autohide = true;
        tilesize = 60;
        mineffect = "genie";
        magnification = false;
        launchanim = true;
        showhidden = false;
        show-recents = false;
        minimize-to-application = true;
        # TODO)) persistent-apps = {};
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "Nlsv"; # List view
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;
        ShowSeconds = true;
        FlashDateSeparators = false;
      };
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
    };
    nixPath = [ "nixpkgs=flake:nixpkgs" ];
  };
}
