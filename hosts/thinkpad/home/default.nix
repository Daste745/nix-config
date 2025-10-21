{
  inputs,
  pkgs,
  config,
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    slack
    thunderbird
    bruno
    obsidian
    feishin
    spotify
    nextcloud-client
    trayscale
    jetbrains.datagrip
    libreoffice
    vlc
    obs-studio
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../../assets
    ../../../home
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    # ./hyprshell.nix
    ./swaync.nix
    ./waybar.nix
    ./wofi.nix
  ];

  graphical.enable = true;
  modules.git.signingKey = config.assets.keys.user.thinkpad;
}
