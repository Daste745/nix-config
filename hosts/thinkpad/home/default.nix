{
  inputs,
  pkgs,
  username,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  customPkgs = inputs.packages.${system};
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.default
    dconf
    slack
    thunderbird
    bruno
    obsidian
    feishin
    jellyfin-tui
    jetbrains.datagrip
    libreoffice-fresh
    vlc
    gimp
    obs-studio
    wl-clipboard
    claude-code
    customPkgs.gnhf
    # TODO)) Replace with a real package once `wt` is packaged properly
    (writeShellApplication {
      name = "wt";
      runtimeInputs = [ python314Packages.uv ];
      text = ''
        unset VIRTUAL_ENV
        exec uv --project ~/Projects/wt run ~/Projects/wt/src/wt/main.py "$@"
      '';
    })
  ];

  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    ../../../assets
    ../../../home
    # ./hyprland
    ./niri
    ./ulauncher
    ./ashell.nix
    ./gtk.nix
    ./nextcloud-client.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swaync.nix
    ./trayscale.nix
    ./volnoti.nix
    # ./waybar.nix
    ./wofi.nix
  ];

  graphical.enable = true;

  services.gnome-keyring.enable = true;
  services.network-manager-applet.enable = true;
}
