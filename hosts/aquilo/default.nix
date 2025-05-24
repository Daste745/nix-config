{ lib, pkgs, ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ../../modules/ssh.nix
  ];

  users.users.stefan = {
    shell = pkgs.fish;
    home = "/Users/stefan";
  };

  networking.hostName = "aquilo";

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit pkgs; };
    users.stefan = import ./home.nix;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
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
