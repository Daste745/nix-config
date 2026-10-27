{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${system}.nh;
    flake = "$HOME/.nix-config";
  };
}
