{
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      allow_markup = true;
      width = 500;
      lines = 10;
      no_actions = true;
      gtk_dark = true;
      key_up = "Up,Ctrl-k";
      key_down = "Down,Ctrl-j";
    };
    style = ''
      * {
        font-family: "Maple Mono", "Monospace";
      }
      #img {
        margin-right: 10px;
      }
    '';
  };
}
