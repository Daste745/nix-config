{ pkgs, ... }:
{
  imports = [
    ./nirimap.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    brightnessctl
    playerctl
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kwallet
    kdePackages.kwallet-pam
    smile
    loupe
    wlogout
    gcr
    networkmanagerapplet
    blueman
    pavucontrol
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
