{ username, ... }:
{
  imports = [
    ../../modules/tailscale.nix
  ];

  system.stateVersion = "24.11";

  wsl = {
    enable = true;
    defaultUser = username;
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

  programs.nix-ld.enable = true; # For VSCode server on WSL

  virtualisation.docker.enable = true;
}
