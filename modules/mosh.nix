{ lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mosh ];

  programs = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    mosh.enable = true;
  };
}
