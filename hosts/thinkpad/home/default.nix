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
    maple-mono.truetype
    maple-mono.NF
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
    ./hyprland.nix
    ./hyprpaper.nix
    # ./hyprshell.nix
    ./waybar.nix
  ];

  graphical.enable = true;
  modules.git.signingKey = config.assets.keys.user.thinkpad;
}
