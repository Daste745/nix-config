{ config, pkgs, ... }:
{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.11";
  };

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        nrs = "sudo nixos-rebuild switch";
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      extraConfig = ''
        pinentry-program "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe"
      '';
    };
  };
}
