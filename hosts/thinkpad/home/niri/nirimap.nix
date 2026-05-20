{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  package = inputs.packages.${system}.nirimap;
in
{
  home.packages = [
    package
  ];

  xdg.configFile."nirimap/config.toml".text = ''
    [display]
    height = 50               # Per-workspace row height in pixels
                              # In "current" mode: total widget height
                              # In "all" mode: height of one workspace row
    max_width_percent = 0.5   # Maximum width as fraction of screen (0.0 - 1.0)
    max_height_percent = 0.8  # Maximum height as fraction of screen (used in "all" mode)
    anchor = "top-right"      # Position: top-left, top-center, top-right,
                              #           bottom-left, bottom-center, bottom-right, center
    margin_x = 10             # Horizontal margin from edge
    margin_y = 10             # Vertical margin from edge
    workspace_mode = "all"    # Which workspaces to show:
                              #   "all"     - stack every workspace vertically (Overview-style)
                              #   "current" - show only the active workspace

    [appearance]
    background = "#1e1e2e"    # Background color (hex)
    window_color = "#45475a"  # Default window rectangle color
    focused_color = "#89b4fa" # Focused window highlight
    border_color = "#6c7086"  # Window border color
    border_width = 1          # Window border thickness
    border_radius = 4         # Corner radius for window rectangles
    gap = 4                   # Gap between windows (in minimap pixels)
    background_opacity = 0.0  # Background opacity (0.0 = transparent, 1.0 = opaque)
                              # Applies in both "current" and "all" modes
    window_opacity = 0.5      # Fill opacity for unfocused windows (0 = outlines only)
    focused_opacity = 0.8     # Fill opacity for the focused window
    workspace_gap = 0                            # Vertical gap between stacked workspaces ("all" mode)
    active_workspace_border_color = "#89b4fa"    # Highlight border for active workspace ("all" mode)
    active_workspace_border_width = 0            # Highlight border thickness ("all" mode)

    [behavior]
    show_on_overview = true           # Keep visible in Niri overview mode
    always_visible = false            # Always show minimap (false = only on focus change)
    hide_timeout_ms = 500             # Milliseconds before hiding after focus change
    show_for_floating_windows = false # When always_visible = false, surface the minimap for
                                      # floating-window events (focus to/from a floating window,
                                      # floating window spawn). Off by default since floating
                                      # windows aren't drawn on the minimap.
  '';

  systemd.user.services.nirimap = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      Description = "A minimal workspace minimap overlay for the Niri Wayland compositor";
      Documentation = "https://github.com/alexandergknoll/nirimap";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe package;
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
