{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
  lock = "${getExe pkgs.swaylock-effects} --daemonize --ignore-empty-password --grace 5 --grace-no-mouse --indicator --clock --fade-in 0.2";
  display = status: "${getExe pkgs.niri} msg action power-${status}-monitors";
  playerctl = command: "${getExe pkgs.playerctl} --all-players ${command}";
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 15 * 60;
        command = lock;
      }
      {
        timeout = 20 * 60;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 60 * 60;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = {
      lock = lock;
      unlock = display "on";
      before-sleep = "${display "off"}; ${playerctl "pause"}; ${lock}";
      after-resume = display "on";
    };
  };
}
