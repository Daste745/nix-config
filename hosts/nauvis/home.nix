{
  inputs,
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../assets
    ../../home
  ];

  modules.zed.wslCompatScript.enable = true;
  services.gpg-agent.pinentryProgramPath = "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe";
}
