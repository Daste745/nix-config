{ pkgs, ... }:
{
  home.packages = with pkgs; [
    file
    tree
    wget
    curl
    htop
    fastfetch
    pfetch
    ripgrep
    xdg-utils
    nixd
    nil
    nix-output-monitor
  ];

  programs.home-manager.enable = true;

  imports = [
    ./fish.nix
    ./git
    ./tmux.nix
    ./vim.nix
  ];
}
