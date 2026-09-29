{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { systems, nixpkgs, ... }:
    let
      eachSystem =
        f: nixpkgs.lib.genAttrs (import systems) (system: f (import nixpkgs { inherit system; }));
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [

          ];
          shellHook = ''

          '';
        };
      });
    };
}
