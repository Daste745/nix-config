{ pkgs, config, ... }:
let
  inherit (config.xdg) configHome;
in
{
  home.packages = with pkgs; [
    wakatime-cli
  ];

  age.secrets.wakatime-cfg = {
    file = ../../secrets/wakatime-cfg.age;
    path = "${configHome}/wakatime/.wakatime.cfg";
  };
}
