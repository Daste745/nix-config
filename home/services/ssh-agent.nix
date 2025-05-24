{ lib, pkgs, ... }:
{
  # NOTE: ssh-agent doesn't work on darwin
  services.ssh-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
  };
}
