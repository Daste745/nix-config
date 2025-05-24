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
    ./mise.nix
    ./git
    ./tmux.nix
    ./vim.nix
  ];
}
