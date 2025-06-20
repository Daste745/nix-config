{ inputs, ... }:
{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.11";
  };

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
  ];

  modules.git.signingKey = (import ../../assets/ssh.nix).users.nauvis;
  services.gpg-agent.pinentryProgramPath = "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe";
}
