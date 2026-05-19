{ pkgs, ... }:
{
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
    gcr
    networkmanagerapplet
    blueman
    pavucontrol
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
