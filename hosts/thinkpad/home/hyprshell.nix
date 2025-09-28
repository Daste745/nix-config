{
  # https://github.com/H3rmt/hyprshell/blob/hyprshell-release/nix/module.nix
  services.hyprshell = {
    enable = true;
    systemd.args = "-v";
    settings = {
      windows = {
        overview = {
          modifier = "super";
          key = "super_l";
        };
        switch = {
          modifier = "alt";
          switch_workspaces = true;
        };
      };
    };
  };
}
