{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.11";

  imports = [
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "stefan";
  };

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    home = "/home/stefan";
    openssh.authorizedKeys.keys = lib.attrValues (import ../../assets/ssh.nix).users;
  };

  networking.hostName = "nauvis";

  environment.systemPackages = with pkgs; [
    git
    inputs.agenix.packages.${system}.default
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true; # For VSCode server on WSL

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.stefan = ./home.nix;
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
