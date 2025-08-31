{
  pkgs,
  lib,
  username,
  ...
}:
let
  inherit (lib) getExe;
in
{
  services.greetd = {
    enable = true;
    settings = {
      # This will be started automatically when greetd starts
      initial_session = {
        command = "Hyprland";
        user = username;
      };
      # Fallback when Hyprland exits or crashes
      default_session = {
        command = "${getExe pkgs.tuigreet} --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
