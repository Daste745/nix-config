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
    gnupg
    tokei
    ripgrep
    ripgrep-all
    hyperfine
    git-crypt
    xdg-utils
    nixd
    nil
    nixfmt-rfc-style
    nixfmt-tree
    nix-output-monitor
  ];

  programs.home-manager.enable = true;

  imports = [
    ./git
    ./fish.nix
    ./mise.nix
    ./nix-index.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./wakatime.nix
  ];
}
