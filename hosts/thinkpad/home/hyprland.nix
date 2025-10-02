{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
in
{
  home.packages = with pkgs; [
    rose-pine-hyprcursor
    brightnessctl
    playerctl
    xfce.thunar
    wofi
    wlogout
    blueman
    networkmanagerapplet
    grim
    slurp
    hyprshot
    gcr
  ];

  services.gnome-keyring.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    plugins = [
      inputs.hyprland-split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      "$mod" = "SUPER";
      "$modCtrl" = "SUPER + CTRL";
      "$modShift" = "SUPER + SHIFT";
      "$terminal" = getExe pkgs.ghostty;
      "$fileManager" = getExe pkgs.xfce.thunar;
      exec-once = [
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "restore-wallpaper"
      ];
      env = [
        "HYPRCURSOR_THEME, rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE, 24"
      ];
      monitor = [
        "eDP-1, 1920x1080@60, 0x0, 1"
        "desc:Ancor Communications Inc BE24A J9LMQS111509, 1920x1200@60, 1920x0, 1"
        "desc:Ancor Communications Inc BE24A K3LMQS042715, 1920x1200@60, 3840x-400, 1, transform, 3"
        "desc:Samsung Electric Company LC34G55T H4ZT103264, 3440x1440@50, 0x-1440, 1"
        ", preferred, auto, 1" # Fallback for unknown monitors
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
        disable_hyprland_logo = true;
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
        "$modShift, s, exec, ${getExe pkgs.hyprshot} -m region --clipboard-only"
        # TODO)) Suspend: ...

        # Media keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set 10+"
        ", XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 10-"
        ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
        ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
        ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} previous"

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
        "$mod, 1, split-workspace, 1"
        "$mod, 2, split-workspace, 2"
        "$mod, 3, split-workspace, 3"
        "$mod, 4, split-workspace, 4"
        "$mod, 5, split-workspace, 5"
        "$mod, 6, split-workspace, 6"
        "$mod, 7, split-workspace, 7"
        "$mod, 8, split-workspace, 8"
        "$mod, 9, split-workspace, 9"
        "$mod, 0, split-workspace, 10"
        "$mod + ALT, h, split-workspace, -1"
        "$mod + ALT, l, split-workspace, +1"
        "$mod, c, togglespecialworkspace, special"

        # Window moving between workspaces - mod + shift + number/direction
        "$modShift, 1, split-movetoworkspace, 1"
        "$modShift, 2, split-movetoworkspace, 2"
        "$modShift, 3, split-movetoworkspace, 3"
        "$modShift, 4, split-movetoworkspace, 4"
        "$modShift, 5, split-movetoworkspace, 5"
        "$modShift, 6, split-movetoworkspace, 6"
        "$modShift, 7, split-movetoworkspace, 7"
        "$modShift, 8, split-movetoworkspace, 8"
        "$modShift, 9, split-movetoworkspace, 9"
        "$modShift, 0, split-movetoworkspace, 10"
        "$modShift, h, split-movetoworkspace, -1"
        "$modShift, l, split-movetoworkspace, +1"
        "$modShift, c, movetoworkspace, special:special"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        # TODO)) Switch off internal display when it's the only one active,
        #        but disable it entirely when there are external displays.
        #        This would mimic how DEs handle closing the lid when plugged into a display.
        ", switch:on:Lid Switch, exec, hyprctl dispatch dpms off eDP-1"
        ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on eDP-1"
      ];
      gesture = [
        "3, horizontal, workspace"
        "4, horizontal, workspace"
        "3, vertical, special, special"
      ];
      plugin = {
        split-monitor-workspaces = {
          count = 10;
          keep_focused = true;
        };
      };
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
}
