{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  assets = config.assets;
in
{
  imports = [
    ../modules/ssh.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    inputs.agenix.packages.${system}.default
  ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  users.users.stefan = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = lib.attrValues assets.keys.user;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
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
