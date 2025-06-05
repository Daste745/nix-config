{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.git;
  mkGitCommand = name: pkgs.writeShellScriptBin name (builtins.readFile ./commands/${name});
  allUserSshKeys = lib.attrValues (import ../../../assets/ssh.nix).users;
  # TODO)) Maybe scope these to only the email they are used for (?)
  allowedSignersEntries = lib.map (key: "* " + key) allUserSshKeys;
in
{
  options = {
    modules.git = {
      signingKey = lib.mkOption {
        type = lib.types.str;
        description = ''
          SSH key for signing commits with git.
        '';
      };
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = "Daste";
      userEmail = "stefankar1000@gmail.com";
      difftastic = {
        enable = true;
        display = "inline";
        background = "dark";
      };
      includes = [
        { path = "~/.user.gitconfig"; }
      ];
      signing = {
        # TODO)) Per-directory signing key
        key = cfg.signingKey;
        format = "ssh";
        signByDefault = true;
      };
      extraConfig = {
        init = {
          defualtBranch = "main";
        };
        pull = {
          ff = "only";
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        worktree = {
          useRelativePaths = true;
        };
        gpg = {
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
      };
      aliases = {
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        unpushed = "log --branches --not --remotes --no-walk --decorate --oneline";
        # Find the base of the current branch, defaulting to the `GIT_DEFAULT_BRANCH` env if not provided
        branch-base = "!f() { git merge-base \${1:-\$GIT_DEFAULT_BRANCH} @; }; f";
        branch-summary = "!f() { git diff --compact-summary \$(git branch-base \$1) @; }; f";
        branch-diff = "!f() { git diff \$(git branch-base \$1) @; }; f";
        # branch-summary, but grepped for `migrations` - useful for Django
        branch-migrations = "!f() { git diff --name-only \$(git branch-base \$1) @ | rg migrations; }; f";
      };
    };

    home.file.".ssh/allowed_signers".text = lib.concatStringsSep "\n" allowedSignersEntries;

    home.packages = [
      (mkGitCommand "git-fixup")
    ];
  };
}
