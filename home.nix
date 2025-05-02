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
