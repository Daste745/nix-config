{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templates.url = "./templates";
  };

  outputs =
    inputs@{
      nixos-wsl,
      ...
    }:
    let
      util = import ./util.nix inputs;
    in
    rec {
      nixosConfigurations = {
        nauvis = util.mkNixosConfiguration "nauvis" {
          extraModules = [
            nixos-wsl.nixosModules.default
          ];
        };
        thinkpad = util.mkNixosConfiguration "thinkpad" {
          extraModules = [
            inputs.disko.nixosModules.disko
          ];
        };
      };
      darwinConfigurations = {
        aquilo = util.mkDarwinConfiguration "aquilo" {
          extraModules = [ ];
        };
      };

      # nix run .#apps.<name>
      apps = {
        thinkpad-vm = {
          type = "app";
          program = "${nixosConfigurations.thinkpad.config.system.build.vm}/bin/run-thinkpad-vm";
        };
      };
    };
}
