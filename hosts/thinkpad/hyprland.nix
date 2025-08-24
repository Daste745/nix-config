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
    settings = {
      "$mod" = "CTRL_SHIFT";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
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
      ];
      # TODO)) Rest of the config
    };
  };
}
