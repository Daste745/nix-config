{
  imports = [
    ../../modules/tailscale.nix
  ];

  system.stateVersion = "24.11";

  networking.hostName = "nauvis";

  wsl = {
    enable = true;
    defaultUser = "stefan";
  };

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/stefan";
  };

  home-manager.users.stefan = ./home.nix;

  programs.nix-ld.enable = true; # For VSCode server on WSL

  virtualisation.docker.enable = true;
}
