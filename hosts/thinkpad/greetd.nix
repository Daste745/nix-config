{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  inherit (lib) getExe getExe';
  niriSessionExe = getExe' config.programs.niri.package "niri-session";
in
{
  services.greetd = {
    enable = true;
    settings = {
      # This will be started automatically when greetd starts
      initial_session = {
        # command = "start-hyprland";
        command = niriSessionExe;
        user = username;
      };
      # Fallback when the WM exits or crashes
      default_session = {
        # command = "${getExe pkgs.tuigreet} --cmd start-hyprland";
        command = "${getExe pkgs.tuigreet} --cmd ${niriSessionExe}";
        user = "greeter";
      };
    };
  };
}
