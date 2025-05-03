{ config, pkgs, ... }:
{
  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;

    fish = {
      enable = true;
      shellAbbrs = {
        # Misc. aliases
        md = "mkdir";
        takeown = "sudo chown -v $(whoami):$(whoami)";
        e = "open .";
        ## Last command, like !! in bash and zsh
        "!!" = { function = "last_history_item"; position = "anywhere"; };
        # Activate a python virtual environment
        acv = { function = "activate_venv"; };

        # Add verbose and interactive by default
        cp = "cp -vi";
        mv = "mv -vi";
        rm = "rm -vi";
        rmdir = "rmdir -v";
        chmod = "chmod -v";

        # Nix
        nrs = "sudo nixos-rebuild switch --flake ~/.nix-config";

        # Git
        ## Common
        gs = "git status";
        gco = "git checkout";
        gl = "git lg";
        gst = "git stash";
        ## add
        ga = "git add";
        gap = "git add --patch";
        ## commit
        gc = "git commit";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gcna = "git commit --amend --no-edit";
        ## restore
        gres = "git restore";
        grp = "git restore --patch";
        grs = "git restore --staged";
        grps = "git restore --patch --staged";
        grsp = "git restore --patch --staged";
        ## push
        gp = "git push";
        gpo = "git push origin @";
        ## rebase
        gr = "git rebase";
        gri = "git rebase -i";
        grc = "git rebase --continue";
        gra = "git rebase --abort";
        grcp = "git rebase --show-current-patch";
        ## diff
        gd = "git diff";
        gdc = "git diff --cached";
        gbs = "git branch-summary";
        gbd = "git branch-diff";
        gbm = "git branch-migrations";

        # Docker
        dc = "docker compose";
        dcu = "docker compose up -d";
        dcd = "docker compose down";
        dcl = "docker compose logs";
        dcp = "docker compose ps";
        dcr = "docker compose run";
        dcw = "docker compose watch";

        # Tmux
        tn = "tmux new-session";
        tl = "tmux ls";
        ta = "tmux attach";
      };
      functions = {
        fish_greeting = "";
        fish_user_key_bindings = ''
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert
          # Then execute the vi-bindings so they take precedence when there's a conflict.
          # Without --no-erase fish_vi_key_bindings will default to
          # resetting all bindings.
          # The argument specifies the initial mode (insert, "default" or visual).
          fish_vi_key_bindings --no-erase insert
          set -g fish_escape_key_delay 10
          # Edit the command buffer in $EDITOR with Ctrl+X
          bind --mode insert \cX 'edit_command_buffer'
        '';
        fish_vcs_prompt = "fish_git_prompt $argv";
        last_history_item = "echo $history[1]";
        activate_venv = ''
          for venv_dir in "venv" ".venv"
              if test -d "$venv_dir" -a -f "$venv_dir/bin/activate.fish"
                  echo "source $venv_dir/bin/activate.fish"
                  return
              end
          end
          echo "# No venv found"
        '';
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      config = {
        global = {
          load_dotenv = false;
          strict_env = true;
          hide_env_diff = false;
        };
      };
    };

    vim = {
      enable = true;
      extraConfig = ''
        " Disable compatibility with vi
        set nocompatible
        " Use 4-wide space tabs
        set shiftwidth=4
        " Tabs are 4-wide
        set tabstop=4
        " Use spaces instead of tabs
        set expandtab
        set smarttab
        " Auto indent
        set ai
        " Smart indent
        set si

        " Highlight matching brackets
        " set showmatch
        " Search non-sensitively, unless capital chars are present
        set ignorecase
        set smartcase
        " Incremental search
        set incsearch
        " Command history
        set history=1000
        " Disable bells
        set noerrorbells
        set novisualbell
        set t_vb=
        set tm=500

        " Highlight syntax
        syntax on
        filetype on
        filetype plugin on
        filetype indent on

        set nobackup
        set nowb
        set noswapfile
      '';
    };

    tmux = {
      enable = true;
      prefix = "C-a";
      mouse = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        # TODO: ofirgall/tmux-window-name - will require setting up python
        yank
        mode-indicator
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-dir '/home/stefan/.cache/tmux/resurrect'
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
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      extraConfig = ''
        pinentry-program "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe"
      '';
    };
  };
}
