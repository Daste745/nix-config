{ lib, pkgs, ... }:
{
  services.skhd = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = ''
      ctrl + cmd - return : open -n -a "Alacritty"
    '';
  };
}
