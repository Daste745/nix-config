{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.xdg) cacheHome stateHome;
  selectedWallpaper = "${cacheHome}/selected-wallpaper";
  currentWallpaper = "${stateHome}/current-wallpaper";
  setWallpaper = pkgs.writeShellApplication {
    name = "set-wallpaper";
    text = ''
      if [ -f ${currentWallpaper} ]; then
        # Start yazi pointing at the selected wallpaper
        SELECTOR_START="$(cat ${currentWallpaper})"
      else
        SELECTOR_START="${config.home.homeDirectory}"
      fi
      yazi --chooser-file ${selectedWallpaper} "$SELECTOR_START"
      # TODO)) Check if selected file is an image
      head -n 1 ${selectedWallpaper} > ${currentWallpaper}
      hyprctl hyprpaper reload ,"$(cat ${currentWallpaper})"
    '';
  };
  restoreWallpaper = pkgs.writeShellApplication {
    name = "restore-wallpaper";
    text = ''
      if [ -f ${currentWallpaper} ]; then
        hyprctl hyprpaper reload ,"$(cat ${currentWallpaper})"
      fi
    '';
  };
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
    };
  };

  home.packages = [
    pkgs.yazi
    setWallpaper
    restoreWallpaper
  ];

  systemd.user.services.restore-wallpaper = {
    Install = {
      WantedBy = [ "hyprpaper.service" ];
    };

    Unit = {
      After = [ "hyprpaper.service" ];
      Description = "Restore previously selected wallpaper";
    };

    Service = {
      ExecStart = lib.getExe (
        pkgs.writeShellScriptBin "restore-wallpaper-delayed" ''
          sleep 5s && ${lib.getExe restoreWallpaper}
        ''
      );
      Type = "oneshot";
    };
  };
}
