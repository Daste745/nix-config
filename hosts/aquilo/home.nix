{ inputs, pkgs, ... }:
{
  home = {
    username = "stefan";
    stateVersion = "24.11";
  };

  home.packages = with pkgs; [
    maple-mono.truetype
    maple-mono.NF
    localsend
    vlc-bin
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../home
  ];

  graphical.enable = true;
  modules.git.signingKey = (import ../../assets/keys.nix).user.aquilo;
}
