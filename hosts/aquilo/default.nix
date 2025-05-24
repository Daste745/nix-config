{ config, lib, pkgs, ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.stefan = {
    shell = pkgs.fish;
    home = "/Users/stefan";
  };

  networking.hostName = "aquilo";

  security.pam.services.sudo_local.touchIdAuth = true;

  # TODO)) Move some of this to user packages
  environment.systemPackages = with pkgs; [
    file
    tree
    wget
    htop
    fastfetch
    git
    nix-output-monitor
    gnupg
    ripgrep
    xdg-utils
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  # programs.nix-ld.enable = true;  # For VSCode server on WSL?

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit pkgs; };
    users.stefan = import ./home.nix;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
