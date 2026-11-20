{ nixpkgs, ... }:
let
  inherit (nixpkgs) lib;
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  mkPackages = pkgs: {
    check-flake-updates = pkgs.callPackage ./check-flake-updates.nix { };
    nirimap = pkgs.callPackage ./nirimap.nix { };
  };
in
lib.genAttrs systems (system: mkPackages nixpkgs.legacyPackages.${system})
