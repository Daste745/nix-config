{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
      };
      animation = [
        "fadeIn, 0"
        "fadeOut, 0"
      ];
      background = {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
      };
      input-field = {
        monitor = "";
        outline_thickness = 1;
        dots_center = false;
        fade_on_empty = true;
        placeholder_text = "<i>Password...</i>";
      };
    };
  };
}
