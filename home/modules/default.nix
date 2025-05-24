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
    dust
    fzf
    fselect
    tokei
    ripgrep
    ripgrep-all
    hyperfine
    mise # Still using in most of my projects
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
