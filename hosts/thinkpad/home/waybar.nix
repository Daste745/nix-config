{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "backlight"
        "battery"
        "cpu"
        "memory"
        "clock"
        "custom/power"
      ];
      "custom/power" = {
        format = " ⏻ ";
        tooltip = false;
        on-click = "wlogout --protocol layer-shell";
      };
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          urgent = "";
          active = "";
          visible = "";
          default = "";
          empty = "•";
        };
        show-special = true;
        special-visible-only = true;
      };
      "hyprland/window" = {
        separate-outputs = true;
        icon = true;
        icon-size = 16;
      };
    };
  };
}
