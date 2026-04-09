{
  inputs,
  pkgs,
  username,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.default
    slack
    thunderbird
    bruno
    obsidian
    feishin
    spotify
    jetbrains.datagrip
    libreoffice-fresh
    vlc
    gimp
    obs-studio
    wl-clipboard
    claude-code
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../../assets
    ../../../home
    ./ulauncher
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    # ./hyprshell.nix
    ./nextcloud-client.nix
    ./swaync.nix
    ./trayscale.nix
    ./waybar.nix
    ./wofi.nix
  ];

  graphical.enable = true;
}
