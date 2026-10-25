{ nixpkgs, ... }:
let
  inherit (nixpkgs) lib;
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  mkPackages = callPackage: {
    check-flake-updates = callPackage ./check-flake-updates.nix { };
    gnhf = callPackage ./gnhf.nix { };
    hypremoji = callPackage ./hypremoji.nix { };
    nirimap = callPackage ./nirimap.nix { };
    volnoti = callPackage ./volnoti.nix { };
  };
in
lib.genAttrs systems (system: mkPackages nixpkgs.legacyPackages.${system}.callPackage)
