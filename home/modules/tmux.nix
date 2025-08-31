{ pkgs, username, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    clock24 = true;
    escapeTime = 0;
    plugins = with pkgs.tmuxPlugins; [
      # TODO: ofirgall/tmux-window-name - will require setting up python
      yank
      mode-indicator
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-dir '/home/${username}/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      # TODO: noscript/tmux-mighty-scroll
      # {
      #   plugin = mightyScroll;
      #   extraConfig = ''
      #     set -g @mighty-scroll-select-pane off
      #     # Use scroll pass-through instead of sending up/down keys
      #     set -g @mighty-scroll-pass-through 'vim nvim htop top'
      #     set -g @mighty-scroll-by-line 'man less pager fzf jira'
      #   '';
      # }
    ];
    extraConfig = ''
      set -g renumber-windows on

      # Open splits in the current pane's directory
      bind \\ split-window -h -c "#{pane_current_path}"
      bind | split-window -v -c "#{pane_current_path}"

      # Status bar
      set -g status-left-length 20
      set -g status-left '#{tmux_mode_indicator}#[bg=white] #S #[default] '
      set -g status-right '#[bg=white] %Y-%m-%d %H:%M #[default]'
    '';
  };
}
