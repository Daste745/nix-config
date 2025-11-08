{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };
  xdg.mime = {
    # Mimetypes: https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types/Common_types
    # Data dirs: $XDG_DATA_DIRS
    # .desktop: ls /etc/profiles/per-user/stefan/share/applications/
    defaultApplications = {
      "text/html" = "zen.desktop";
      "application/pdf" = "zen.desktop";
    };
  };
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
    ];
  };
}
