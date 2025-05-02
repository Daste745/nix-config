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
}
