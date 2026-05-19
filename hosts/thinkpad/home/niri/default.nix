{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kwallet
    kdePackages.kwallet-pam
    smile
    loupe
    gcr
    networkmanagerapplet
    blueman
    pavucontrol
    inputs.packages.${system}.volnoti
    (pkgs.writeShellScriptBin "show-volume" ''
      VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2)
      PERCENT=$(echo "scale=2; $VOLUME * 100" | ${getExe pkgs.bc}| awk '{print ($1 > 100) ? 100 : $1}')
      MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 3)
      if [ "$MUTED" = "[MUTED]" ]; then
        volnoti-show -m "$PERCENT"
      else
        volnoti-show "$PERCENT"
      fi
    '')
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
