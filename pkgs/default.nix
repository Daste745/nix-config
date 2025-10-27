inputs:
let
  lib = inputs.nixpkgs.lib;
in
{
  x86_64-linux =
    let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      args = inputs // {
        inherit lib pkgs;
      };
    in
    {
      volnoti = import ./volnoti.nix args;
      hypremoji = import ./hypremoji args;
    };
}
