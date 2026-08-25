inputs:
let
  lib = inputs.nixpkgs.lib;
  mkSystemPackages =
    system: f:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    f (inputs // { inherit lib pkgs; });
in
{
  x86_64-linux = mkSystemPackages "x86_64-linux" (args: {
    volnoti = args.pkgs.callPackage ./volnoti.nix { };
    nirimap = args.pkgs.callPackage ./nirimap.nix { };
    gnhf = args.pkgs.callPackage ./gnhf.nix { };
    check-flake-updates = args.pkgs.callPackage ./check-flake-updates.nix { };
    dix-fzf = args.pkgs.callPackage ./dix-fzf.nix { };
  });
  aarch64-darwin = mkSystemPackages "aarch64-darwin" (args: {
    check-flake-updates = args.pkgs.callPackage ./check-flake-updates.nix { };
    dix-fzf = args.pkgs.callPackage ./dix-fzf.nix { };
    gnhf = args.pkgs.callPackage ./gnhf.nix { };
  });
}
