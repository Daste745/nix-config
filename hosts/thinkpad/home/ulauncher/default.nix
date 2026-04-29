{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  ulauncher = inputs.ulauncher.packages.${system}.ulauncher6;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = [ ulauncher ];

  xdg.configFile = {
    # FIXME)) ~/.nix-config shouldn't be hardcoded
    ulauncher.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/hosts/thinkpad/home/ulauncher/config";
  };

  # https://github.com/Ulauncher/Ulauncher/blob/main/ulauncher.service
  systemd.user.services.ulauncher = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      Description = "ulauncher application launcher service";
      Documentation = "https://ulauncher.io";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "dbus";
      BusName = "io.ulauncher.Ulauncher";
      ExecStart = "${lib.getExe' ulauncher "ulauncher"} --daemon";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
