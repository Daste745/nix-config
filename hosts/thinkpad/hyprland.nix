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
      # TODO)) Rest of the config
    };
  };
}
