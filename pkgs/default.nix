inputs:
let
  lib = inputs.nixpkgs.lib;
  mkSystemPackages =
    system: f:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    f (inputs // { inherit lib pkgs; });
in
{
  x86_64-linux = mkSystemPackages "x86_64-linux" (args: {
    volnoti = import ./volnoti.nix args;
    check-flake-updates = import ./check-flake-updates.nix args;
  });
  aarch64-darwin = mkSystemPackages "aarch64-darwin" (args: {
    check-flake-updates = import ./check-flake-updates.nix args;
  });
}
