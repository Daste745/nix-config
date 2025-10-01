{ pkgs, ... }:
let
  configDir = "~/.nix-config";
  nrsAbbr =
    if pkgs.stdenv.hostPlatform.isLinux then
      "sudo pixos-rebuild switch --flake ${configDir}"
    else
      "sudo darwin-rebuild switch --flake ${configDir} &| nom";
in
{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      # Misc. aliases
      md = "mkdir";
      takeown = "sudo chown -v $(whoami):$(whoami)";
      e = "open .";
      ## Last command, like !! in bash and zsh
      "!!" = {
        function = "last_history_item";
        position = "anywhere";
      };
      # Activate a python virtual environment
      acv = {
        function = "activate_venv";
      };

      # Add verbose and interactive by default
      cp = "cp -vi";
      mv = "mv -vi";
      rm = "rm -vi";
      rmdir = "rmdir -v";
      chmod = "chmod -v";

      # Nix
      nrs = nrsAbbr;
      ns = {
        expansion = "nom shell nixpkgs#%";
        setCursor = "%";
      };

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
      tmpdir = "cd (mktemp -d /tmp/XXXXXXX)";
      forever = ''
        if test -z "$argv"
          echo "Usage: forever [-q] <command>"
          return 1
        end

        argparse --stop-nonopt --name "forever" "q" -- $argv
        or return

        set verbose true
        if test -n "$_flag_q"
          set verbose false
        end

        while true
          $verbose && echo "[forever] $argv"
          $argv
          set -l signal (fish_status_to_signal "$status")
          if test $signal = "SIGINT"
            $verbose && echo "[forever] Received SIGINT, exiting..."
            break
          end
          sleep 0.1s
        end
      '';
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
    interactiveShellInit = ''
      function __ssh_agent_after_start
        while ! pgrep -f ssh-agent > /dev/null
            sleep 1s
        end
        ssh-add -q
      end
      # Run the ssh-agent after-start hook in the background
      __ssh_agent_after_start &> /dev/null
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    config = {
      global = {
        load_dotenv = false;
        strict_env = true;
        hide_env_diff = false;
      };
    };
    nix-direnv.enable = true;
  };
}
