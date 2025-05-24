{ config, pkgs, ... }:
{
  home = {
    username = "stefan";
    # TODO)) homeDirectory (???)
    stateVersion = "24.11";
  };

  home.packages = with pkgs; [
    maple-mono.truetype
  ];

  imports = [
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
    ./alacritty.nix
  ];

  programs.home-manager.enable = true;
}
