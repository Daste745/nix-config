{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  home.packages = with pkgs; [
    brightnessctl
    xfce.thunar
    wofi
    wlogout
    blueman
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$modCtrl" = "SUPER + CTRL";
      "$modShift" = "SUPER + SHIFT";
      "$terminal" = getExe pkgs.ghostty;
      "$fileManager" = getExe pkgs.xfce.thunar;
      exec-once = [
        "${pkgs.blueman}/bin/blueman-applet"
      ];
      general = {
        border_size = 1;
        gaps_in = 0;
        gaps_out = 0;
        resize_on_border = true;
      };
      animations = {
        bezier = [
          "easeOut, 0.1, 1, 0.1, 1"
        ];
        animation = [
          "windows, 1, 2, easeOut, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 2.5, easeOut"
          "workspaces, 1, 3.5, easeOut, slide"
          "specialWorkspace, 1, 3, easeOut, slidevert"
        ];
      };
      input = {
        kb_layout = "pl";
        kb_options = "caps:escape";
        repeat_delay = 200;
        repeat_rate = 50;
        accel_profile = "flat";
        scroll_method = "2fg"; # 2 fingers
        follow_mouse = 2;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.6;
        };
      };
      gestures = {
        workspace_swipe_min_speed_to_force = 10;
      };
      misc = {
        middle_click_paste = false;
      };
      dwindle = {
        pseudotile = true;
      };
      windowrule = [
        # TODO)) "float, class:^(blueman-manager)$"
        # TODO)) Nextcloud
        # TODO)) Bitwarden in firefox
        # TODO)) Screen sharing picker portal
        "keepaspectratio, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "noborder, class:^(firefox)$, title:^(Picture-in-Picture)$"
        "float, title:^(Picture-in-Picture)$"
      ];
      bind = [
        # Misc.
        "$mod, Q, killactive"
        "$mod, return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, pkill wofi || wofi --show drun"
        "ALT, space, exec, pkill wofi || wofi --show drun"
        "$mod, F, togglefloating"
        ", F11, fullscreen"
        "$mod + SHIFT + CTRL, l, exec, ${getExe pkgs.hyprlock}"
        # TODO)) Suspend: ...

        # Media keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 10+"
        ", XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 10-"

        # Window focus - mod + direction
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Window moving - mod + ctrl + direction
        "$modCtrl, left, movewindow, l"
        "$modCtrl, right, movewindow, r"
        "$modCtrl, up, movewindow, u"
        "$modCtrl, down, movewindow, d"
        "$modCtrl, h, movewindow, l"
        "$modCtrl, l, movewindow, r"
        "$modCtrl, k, movewindow, u"
        "$modCtrl, j, movewindow, d"

        # Workspace focus - mod + number/direction
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, left, workspace, -1"
        "$mod, right, workspace, +1"

        # Window moving between workspaces - mod + shift + number/direction
        "$modShift, 1, movetoworkspace, 1"
        "$modShift, 2, movetoworkspace, 2"
        "$modShift, 3, movetoworkspace, 3"
        "$modShift, 4, movetoworkspace, 4"
        "$modShift, 5, movetoworkspace, 5"
        "$modShift, 6, movetoworkspace, 6"
        "$modShift, 7, movetoworkspace, 7"
        "$modShift, 8, movetoworkspace, 8"
        "$modShift, 9, movetoworkspace, 9"
        "$modShift, 0, movetoworkspace, 10"
        "$modShift, left, movetoworkspace, -1"
        "$modShift, right, movetoworkspace, +1"
        "$modShift, h, movetoworkspace, -1"
        "$modShift, l, movetoworkspace, +1"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      gesture = [
        "3, horizontal, workspace"
        "4, horizontal, workspace"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on_timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

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
    };
  };
}
