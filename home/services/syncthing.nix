{ ... }:
{
  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
    settings.options = {
      urAccepted = -1;
      relaysEnabled = true;
      localAnnounceEnabled = true;
    };
  };
}
