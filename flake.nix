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
    templates.url = "./templates";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
      agenix,
      ...
    }:
    rec {
      nixosConfigurations = {
        nauvis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            ./assets
            ./hosts/nauvis
          ];
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            ./assets
            ./hosts/thinkpad
          ];
        };
      };
      darwinConfigurations = {
        aquilo = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            agenix.darwinModules.default
            ./assets
            ./hosts/aquilo
          ];
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
