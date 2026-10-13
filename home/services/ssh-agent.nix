{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # NOTE: ssh-agent doesn't work on darwin
  services.ssh-agent = lib.mkIf isLinux {
    enable = true;
  };
}
