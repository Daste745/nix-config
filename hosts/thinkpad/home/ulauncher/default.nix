{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = [ pkgs.ulauncher ];

  xdg.configFile = {
    # FIXME)) ~/.nix-config shouldn't be hardcoded
    ulauncher.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/hosts/thinkpad/home/ulauncher/config";
  };

  systemd.user.services.ulauncher = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      Description = "ulauncher application launcher service";
      Documentation = "https://ulauncher.io";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.ulauncher} --hide-window";
      Restart = "on-failure";
    };
  };
}
