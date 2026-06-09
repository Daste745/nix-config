{ pkgs, ... }: {
  home.packages = with pkgs; [
    waypaper
  ];

  services.awww.enable = true;
}
