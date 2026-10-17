# Darwin version of `programs.mosh` from nixpkgs
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/mosh.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.mosh;
in
{
  options.programs.mosh = {
    enable = lib.mkEnableOption "mosh";
    package = lib.mkPackageOption pkgs "mosh" { };
    # NOTE: `openFirewall` and `withUtempter` are not supported on Darwin
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
