{
  # TODO)) ghostty
  programs.kitty.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      exec-once = "$terminal";
      # TODO)) Rest of the config
    };
  };
}
