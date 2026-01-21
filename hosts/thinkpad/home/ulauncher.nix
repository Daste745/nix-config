{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.ulauncher ];

  # TODO)) Move configs into separate
  xdg.configFile."ulauncher/settings.json".text = ''
    {
      "blacklisted-desktop-dirs": "/usr/share/locale:/usr/share/app-install:/usr/share/kservices5:/usr/share/fk5:/usr/share/kservicetypes5:/usr/share/applications/screensavers:/usr/share/kde4:/usr/share/mimelnk",
      "clear-previous-query": false,
      "disable-desktop-filters": false,
      "grab-mouse-pointer": true,
      "hotkey-show-app": "<Primary>space",
      "render-on-screen": "mouse-pointer-monitor",
      "show-indicator-icon": false,
      "show-recent-apps": "5",
      "terminal-command": "ghostty",
      "theme-name": "dark"
    }
  '';
  # https://ext.ulauncher.io/
  xdg.configFile."ulauncher/extensions.json".text = ''
    {
      "com.github.orcunulutas.ulauncher-token-generator": {
        "id": "com.github.orcunulutas.ulauncher-token-generator",
        "url": "https://github.com/orcunulutas/ulauncher-token-generator",
        "updated_at": "2026-01-21T17:25:53.331182",
        "last_commit": "e3a6e5082a4efb8f5e13f48d750e0564ed1373fb",
        "last_commit_time": "2026-01-10T23:11:38"
      },
      "com.github.tobineben.ulauncher-bluetooth-connection-toggle": {
        "id": "com.github.tobineben.ulauncher-bluetooth-connection-toggle",
        "url": "https://github.com/TobiNeben/ulauncher-bluetooth-connection-toggle",
        "updated_at": "2026-01-21T17:30:13.202881",
        "last_commit": "9c30c8e42f0054aba9adb6015a8f5a8846fc457e",
        "last_commit_time": "2025-11-02T19:05:34"
      }
    }
  '';

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
