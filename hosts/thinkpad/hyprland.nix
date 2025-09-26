{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  home.packages = with pkgs; [
    xfce.thunar
    wofi
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$modCtrl" = "SUPER + CTRL";
      "$modShift" = "SUPER + SHIFT";
      "$terminal" = getExe pkgs.ghostty;
      "$fileManager" = getExe pkgs.xfce.thunar;
      "$menu" = "${getExe pkgs.wofi} --show drun";
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
      misc = {
        middle_click_paste = false;
      };
      dwindle = {
        pseudotile = true;
      };
      bind = [
        # Misc.
        "$mod, Q, killactive"
        "$mod, return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"
        "$mod, F, togglefloating"
        ", F11, fullscreen"
        # TODO)) Lock: "$mod, l, exec, swaylock"
        # TODO)) Suspend: ...

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
    };
  };
}
