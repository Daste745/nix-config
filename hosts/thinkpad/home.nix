{
  inputs,
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

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../assets
    ../../home
    ./hyprland.nix
  ];

  graphical.enable = true;
  modules.git.signingKey = config.assets.keys.user.thinkpad;
}
