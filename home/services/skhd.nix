{ lib, pkgs, ... }:
{
  services.skhd = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = ''
      # FIXME)) Alacritty window name and icon are ugly :^(
      ctrl + cmd - return : alacritty
    '';
  };
}
