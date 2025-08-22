{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableFishIntegration = true;
    settings = {
      maximize = true;
      window-height = 1000;
      window-width = 1000;
      theme = "Afterglow";
      font-family = "Maple Mono";
      font-size = "12";
      macos-titlebar-proxy-icon = "hidden";
    };
  };
}
