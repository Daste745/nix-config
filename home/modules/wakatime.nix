{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    wakatime
  ];

  age.secrets.wakatime-cfg = {
    file = ../../secrets/wakatime-cfg.age;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };
}
