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
  home.packages = [
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

  services.volnoti = {
    enable = true;
    package = pkgs.writeShellScriptBin "volnoti-wrapped" ''
      exec ${inputs.packages.${system}.volnoti}/bin/volnoti -t 1 -a 1.0 -r 0 "$@"
    '';
  };
}
