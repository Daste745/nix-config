{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO)) ghostty
    kitty
    xfce.thunar
    wofi
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = with pkgs; {
      "$mod" = "CTRL_SHIFT";
      "$terminal" = lib.getBin kitty;
      "$fileManager" = lib.getBin xfce.thunar;
      "$menu" = "wofi --show drun";
      bind = [
        "$mod, Q, killactive"
        "$mod, enter, exec, $terminal"
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
