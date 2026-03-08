{ config, ... }:
let
  inherit (config.xdg) dataHome;
in
{
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
      "--disable-ctrl-r"
    ];
    settings = {
      keymap_mode = "vim-insert";
      update_check = false;
      sync_address = "https://atuin.daste.cloud";
      sync_frequency = "5m";
      sync.records = true;
    };
  };

  programs.fish.interactiveShellInit = ''
    bind / _atuin_search
  '';

  age.secrets.atuin-key = {
    file = ../../secrets/atuin-key.age;
    path = "${dataHome}/atuin/key";
  };
}
