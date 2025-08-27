{ lib, ... }:
{
  options.graphical = {
    enable = lib.mkEnableOption "graphical environment modules";
  };

  imports = [
    ./alacritty.nix
    ./ghostty.nix
  ];
}
