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
    fzf
    ripgrep
    xdg-utils
    nixd
    nil
    nixfmt-rfc-style
    nixfmt-tree
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
