inputs:
let
  username = "stefan";

  inherit (inputs)
    nixpkgs
    nix-darwin
    home-manager
    agenix
    ;

  mkCommonModules = hostname: [
    ./assets
    ./hosts/common.nix
    ./hosts/${hostname}
    {
      networking.hostName = hostname;
    }
  ];
in
{
  mkNixosConfiguration =
    hostname:
    { extraModules }:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs username;
        isLinux = true;
      };
      modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
      ]
      ++ (mkCommonModules hostname)
      ++ extraModules;
    };

  mkDarwinConfiguration =
    hostname:
    { extraModules }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs username;
        isLinux = false;
      };
      modules = [
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default
      ]
      ++ (mkCommonModules hostname)
      ++ extraModules;
    };
}
