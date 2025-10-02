{ config, pkgs, ... }:
let
  inherit (config.xdg) cacheHome stateHome;
  currentWallpaper = "${stateHome}/current-wallpaper";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
    };
  };

  home.packages = with pkgs; [
    yazi
    (pkgs.writeShellApplication {
      name = "set-wallpaper";
      text = ''
        yazi --chooser-file ${cacheHome}/selected-wallpaper ${config.home.homeDirectory}
        # TODO)) Check if selected file is an image
        head -n 1 ${cacheHome}/selected-wallpaper > ${currentWallpaper}
        hyprctl hyprpaper reload ,"$(cat ${currentWallpaper})"
      '';
    })
    # Add to hyprland config `exec-once restore-wallpaper`
    (pkgs.writeShellApplication {
      name = "restore-wallpaper";
      text = ''
        if [ -f ${currentWallpaper} ]; then
          hyprctl hyprpaper reload ,"$(cat ${currentWallpaper})"
        fi
      '';
    })
  ];
}
