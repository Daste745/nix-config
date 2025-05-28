{ inputs, ... }:
{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.11";
  };

  imports = [
    inputs.agenix.homeManagerModules.default
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
  ];

  services.gpg-agent.pinentryProgramPath = "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe";
}
