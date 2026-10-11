{ username, ... }:
{
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username} = ./home.nix;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
    startup.chime = false;
    defaults = {
      dock = {
        autohide = true;
        tilesize = 60;
        mineffect = "genie";
        magnification = false;
        launchanim = true;
        showhidden = false;
        show-recents = false;
        minimize-to-application = true;
        # TODO)) persistent-apps = {};
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "Nlsv"; # List view
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;
        ShowSeconds = true;
        FlashDateSeparators = false;
      };
    };
  };
}
