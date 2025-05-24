{ config, pkgs, ... }:
{
  home = {
    username = "stefan";
    # TODO)) homeDirectory (???)
    stateVersion = "24.11";
  };

  imports = [
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
  ];

  programs.home-manager.enable = true;
}
