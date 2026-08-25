inputs:
let
  mkSystemPackages = system: f: f (inputs.nixpkgs.legacyPackages.${system}.callPackage);
in
{
  x86_64-linux = mkSystemPackages "x86_64-linux" (callPackage: {
    volnoti = callPackage ./volnoti.nix { };
    nirimap = callPackage ./nirimap.nix { };
    gnhf = callPackage ./gnhf.nix { };
    check-flake-updates = callPackage ./check-flake-updates.nix { };
    dix-fzf = callPackage ./dix-fzf.nix { };
  });
  aarch64-darwin = mkSystemPackages "aarch64-darwin" (callPackage: {
    check-flake-updates = callPackage ./check-flake-updates.nix { };
    dix-fzf = callPackage ./dix-fzf.nix { };
    gnhf = callPackage ./gnhf.nix { };
  });
}
