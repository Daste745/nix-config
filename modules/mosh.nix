{
  lib,
  pkgs,
  isLinux,
  ...
}:
{
  environment.systemPackages = [ pkgs.mosh ];
  programs = lib.optionalAttrs isLinux { mosh.enable = true; };
}
