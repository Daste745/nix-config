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
    zed-editor
    inputs.zen-browser.packages.${pkgs.system}.default
    slack
    thunderbird
    bruno
    obsidian
    feishin
    spotify
    nextcloud-client
    trayscale
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../../assets
    ../../../home
    ./hyprland.nix
    ./hyprshell.nix
  ];

  graphical.enable = true;
  modules.git.signingKey = config.assets.keys.user.thinkpad;
}
