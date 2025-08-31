inputs:
let
  inherit (inputs)
    nixpkgs
    nix-darwin
    home-manager
    agenix
    ;
in
{
  mkNixosConfiguration =
    hostname:
    { extraModules }:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        ./assets
        ./hosts/common.nix
        ./hosts/${hostname}
      ]
      ++ extraModules;
    };

  mkDarwinConfiguration =
    hostname:
    { extraModules }:
    nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default
        ./assets
        ./hosts/common.nix
        ./hosts/${hostname}
      ]
      ++ extraModules;
    };
}
