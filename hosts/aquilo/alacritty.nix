{
  programs.alacritty = {
    enable = true;
    settings = {
        window.startup_mode = "Maximized";
        scrolling.history = 100000;
        font = {
          size = 12.0;
          normal.family = "Maple Mono";
          normal.style = "Regular";
        };
        selection.save_to_clipboard = true;
    };
  };
}
