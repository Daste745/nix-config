{ lib, pkgs, ... }:
let
  terminal = lib.getExe pkgs.ghostty;
  terminalExec = command: "${terminal} -e ${command}";
  focusWindow = pkgs.writeShellScriptBin "focus-window" ''
    address=$1
    button=$2

    # https://api.gtkd.org/gdk.c.types.GdkEventButton.button.html
    if [ $button -eq 1 ]; then
      # Left click: focus window
      hyprctl keyword cursor:no_warps true
      hyprctl dispatch focuswindow address:$address
      hyprctl keyword cursor:no_warps false
    elif [ $button -eq 2 ]; then
      # Middle click: close window
      hyprctl dispatch closewindow address:$address
    fi
  '';
in
{
  home.packages = [
    focusWindow
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # https://github.com/Alexays/Waybar/wiki
    settings.mainBar = {
      layer = "top";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "tray"
        "bluetooth"
        "network"
        "pulseaudio"
        "backlight"
        "battery"
        "cpu"
        "memory"
        "custom/notification"
        "clock"
        "custom/power"
      ];
      "hyprland/workspaces" = {
        format = "{icon}{windows}";
        format-icons = {
          urgent = " ";
          active = " ";
          visible = " ";
          empty = "  ";
          default = "";
        };
        workspace-taskbar = {
          enable = true;
          update-active-window = true;
          icon-size = 16;
          on-click-window = "${lib.getExe focusWindow} {address} {button}";
        };
        show-special = true;
        special-visible-only = true;
      };
      "hyprland/window" = {
        separate-outputs = true;
        icon = true;
        icon-size = 16;
      };
      "tray" = {
        spacing = 4;
      };
      "bluetooth" = {
        format-on = "<span size='12pt'>  </span>";
        format-off = "<span size='12pt'> 󰂲 </span>";
        format-connected = "<span size='12pt'> 󰂱 </span>";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "blueman-manager";
      };
      "network" = {
        format = "  {ifname}";
        format-wifi = "   {signalStrength}%";
        format-ethernet = "  {ipaddr}/{cidr}";
        tooltip-format = "  {ifname} via {gwaddr}";
        tooltip-format-wifi = "   {essid} ({signalStrength}%)";
        tooltip-format-ethernet = "  {ifname}";
        tooltip-format-disconnected = "Disconnected";
        on-click = terminalExec "nmtui";
      };
      "pulseaudio" = {
        format = "{icon}  {volume}%";
        format-muted = "";
        format-icons = [
          ""
          " "
        ];
        on-click = "pavucontrol";
      };
      "backlight" = {
        format = "{icon}  {percent}%";
        format-icons = [
          "󰃞"
          "󰃟"
          "󰃠"
        ];
      };
      "battery" = {
        format = "{icon}  {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      "cpu" = {
        format = "  {usage}%";
        interval = 1;
      };
      "memory" = {
        format = "  {percentage}%";
        tooltip-format = "{used:0.1f}/{total:0.1f}GiB used";
        interval = 1;
      };
      "custom/notification" = {
        tooltip = true;
        format = " {icon} ";
        format-icons = {
          notification = "󱅫";
          none = "󰂜";
          dnd-notification = "󰂠";
          dnd-none = "󰪓";
          inhibited-notification = "󰂛";
          inhibited-none = "󰪑";
          dnd-inhibited-notification = "󰂛";
          dnd-inhibited-none = "󰪑";
        };
        return-type = "json";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
      };
      "clock" = {
        format = " {:%H:%M:%S}";
        interval = 1;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        timezone = "Europe/Warsaw";
        # TODO)) locale = "pl_PL.UTF-8";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "left";
          on-scroll = 1;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click = "mode";
          on-click-middle = "reset";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      "custom/power" = {
        format = " ⏻  ";
        tooltip = false;
        on-click = "wlogout --protocol layer-shell";
      };
    };
  };
}
