{ pkgs, ... }:
{
  system.stateVersion = "24.11";

  imports = [
    ../../modules/ssh.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "stefan";
  };

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = (import ../../assets/ssh.nix).publicKeys;
  };

  networking.hostName = "nauvis";

  environment.systemPackages = with pkgs; [
    git
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true; # For VSCode server on WSL

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit pkgs; };
    users.stefan = import ./home.nix;
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
