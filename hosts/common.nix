{
  inputs,
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  assets = config.assets;
in
{
  imports = [
    ../modules/mosh.nix
    ../modules/ssh.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    inputs.agenix.packages.${system}.default
    inputs.pinix.packages.${system}.default
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  time.timeZone = "Europe/Warsaw";

  users.users.${username} = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = lib.attrValues assets.keys.user;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
      inherit username;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        username
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
