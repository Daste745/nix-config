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
      bind = [
        "$mod, Q, killactive"
        "$mod, return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
      ];
    };
  };
}
