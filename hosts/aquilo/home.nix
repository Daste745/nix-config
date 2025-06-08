{ inputs, pkgs, ... }:
{
  home = {
    username = "stefan";
    stateVersion = "24.11";
  };

  home.packages = with pkgs; [
    maple-mono.truetype
    maple-mono.NF
    # TODO)) Install this as an .app
    localsend
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
    ./alacritty.nix
  ];

  modules.git.signingKey = (import ../../assets/ssh.nix).users.aquilo;
}
