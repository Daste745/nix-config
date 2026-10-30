{ nixpkgs, ... }:
let
  inherit (nixpkgs) lib;
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  mkPackages = callPackage: {
    check-flake-updates = callPackage ./check-flake-updates.nix { };
    nirimap = callPackage ./nirimap.nix { };
    volnoti = callPackage ./volnoti.nix { };
  };
in
lib.genAttrs systems (system: mkPackages nixpkgs.legacyPackages.${system}.callPackage)
