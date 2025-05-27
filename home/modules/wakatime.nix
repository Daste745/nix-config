{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wakatime
  ];

  # age.secrets.wakatime-cfg.file =
}
