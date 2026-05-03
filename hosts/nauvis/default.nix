{
  username,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe';
in
{
  imports = [
    ../../modules/tailscale.nix
  ];

  system.stateVersion = "24.11";

  wsl = {
    enable = true;
    defaultUser = username;
    extraBin = [
      # Zed uses `wsl.exe ... --exec cp ...` to copy language server files into WSL,
      # which breaks when `cp` isn't in /bin, /usr/bin, etc.
      # https://github.com/zed-industries/zed/issues/52150#issuecomment-4137482439
      { src = getExe' pkgs.coreutils "cp"; }
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/${username}";
  };

  home-manager.users.${username} = ./home.nix;

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;
}
