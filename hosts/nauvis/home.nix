{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.11";
  };

  imports = [
    ../../home/modules
    ../../home/services
    ../../home/xdg.nix
  ];

  services.gpg-agent.pinentryProgramPath =
    "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe";
}
