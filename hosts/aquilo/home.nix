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
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
    ./alacritty.nix
  ];

  modules.git.signingKey = (import ../../assets/keys.nix).user.aquilo;
}
