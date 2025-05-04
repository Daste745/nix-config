{ pkgs, ... }:
{
  system.stateVersion = "24.11";

  wsl = {
    enable = true;
    defaultUser = "stefan";
  };

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    file
    tree
    wget
    htop
    fastfetch
    git
    nix-output-monitor
    gnupg
    ripgrep
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true;  # For VSCode server on WSL

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.stefan = import ./../../home.nix;
  };

  nix = {
    settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    };
  };
}
