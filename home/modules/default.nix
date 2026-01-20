{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  customPkgs = inputs.packages.${system};
in
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
    mosh
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
    nixfmt
    nixfmt-tree
    nix-output-monitor
    comma
    customPkgs.check-flake-updates
  ];

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  imports = [
    ./fish
    ./git
    ./zed
    ./btop.nix
    ./dix.nix
    ./mise.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./wakatime.nix
  ];
}
