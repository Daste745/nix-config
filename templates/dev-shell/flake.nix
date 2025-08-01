{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { systems, nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = eachSystem (
        { system, pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [

            ];
            shellHook = ''

            '';
          };
        }
      );
    };
}
