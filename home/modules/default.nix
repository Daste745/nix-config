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
    xh
    htop
    fastfetch
    dust
    fzf
    jq
    gnupg
    tokei
    ripgrep
    hyperfine
    xdg-utils
    nixd
    nil
    nixfmt
    nixfmt-tree
    nix-output-monitor
    nix-sweep
    comma
    dix
    customPkgs.check-flake-updates
  ];

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  imports = [
    ./fish
    ./git
    ./zed
    ./atuin.nix
    ./btop.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
    ./wakatime.nix
  ];
}
