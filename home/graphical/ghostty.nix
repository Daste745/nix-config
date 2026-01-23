{
  pkgs,
  lib,
  config,
  isLinux,
  ...
}:
{
  programs.ghostty = lib.mkIf config.graphical.enable {
    enable = true;
    # NOTE: Using `ghostty-bin` on MacOS
    package = if isLinux then pkgs.ghostty else pkgs.ghostty-bin;
    enableFishIntegration = true;
    settings = {
      maximize = true;
      # FIXME: Remove arbitrary window sizes once `maximize = true` works on MacOS
      window-height = 1000;
      window-width = 1000;
      theme = "Afterglow";
      font-family = "Maple Mono";
      font-size = "12";
      quit-after-last-window-closed = true;
      macos-titlebar-proxy-icon = "hidden";
      app-notifications = "no-clipboard-copy";
      shell-integration-features = "cursor,no-sudo,title,ssh-env,ssh-terminfo";
    };
  };
}
