{ pkgs, ... }:
{
  home.packages = with pkgs; [
    killall
    file
    tree
    unzip
    wget
    curl
    httpie
    htop
    fastfetch
    dust
    fzf
    gnupg
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
    comma
  ];

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  imports = [
    ./git
    ./zed
    ./dix.nix
    ./fish.nix
    ./mise.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./wakatime.nix
  ];
}
