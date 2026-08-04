{ config, ... }:
let
  inherit (config.xdg) dataHome stateHome;
in
{
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
      "--disable-ctrl-r"
    ];
    # https://docs.atuin.sh/cli/configuration/config/
    settings = {
      keymap_mode = "vim-insert";
      update_check = false;
      sync_address = "https://atuin.daste.cloud";
      sync_frequency = "5m";
      sync.records = true;
      show_tabs = false;
      logs.dir = "${stateHome}/atuin/logs";
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
