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
    # FIXME)) Drop volnoti and replace with a wayland-native overlay
    volnoti = pkgs.callPackage ./volnoti.nix {
      # Completely ignore `gtk2` being broken fow now
      # FIXME)) Remove this ugly hack and just don't use `gtk2`
      gtk2 = (pkgs.gtk2.overrideAttrs (final: prev: { meta.broken = false; }));
    };
  };
in
lib.genAttrs systems (system: mkPackages nixpkgs.legacyPackages.${system})
