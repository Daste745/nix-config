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
    ../../assets
    ../../home
  ];

  graphical.enable = true;
  modules.git.signingKey = config.assets.keys.user.aquilo;
}
