{ inputs, ... }:
{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "25.11";
  };

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../home
    ./hyprland.nix
  ];

  graphical.enable = true;
  modules.git.signingKey = (import ../../assets/keys.nix).user.thinkpad;
}
