{ lib, isLinux, ... }:
{
  # NOTE: ssh-agent doesn't work on darwin
  services.ssh-agent = lib.mkIf isLinux {
    enable = true;
  };
}
