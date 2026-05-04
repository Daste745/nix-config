{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.modules.git;
  inherit (config.xdg) configHome;
  mkGitCommand = name: pkgs.writeShellScriptBin name (builtins.readFile ./commands/${name});
  email = "stefankar1000@gmail.com";
  allUserSshKeys = lib.attrValues config.assets.keys.user;
  mkAllowedSigner = key: "${email} namespaces=\"git\" ${key}";
  allowedSignersEntries = lib.map mkAllowedSigner allUserSshKeys;
in
{
  options.modules.git = {
    signingKey = lib.mkOption {
      type = lib.types.str;
      description = ''
        SSH key for signing commits with git.
      '';
      default = config.assets.keys.user.${hostname};
    };
  };

  config = {
    programs.git = {
      enable = true;
      includes = [
        # TODO)) Remove this include once migrated to ~/.config/git/user-config on all machines
        { path = "~/.user.gitconfig"; }
        { path = "${configHome}/git/user-config"; }
      ];
      signing = {
        # TODO)) Per-directory signing key
        key = cfg.signingKey;
        format = "ssh";
        signByDefault = true;
      };
      settings = {
        user = {
          name = "Daste";
          inherit email;
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          ff = "only";
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        rebase = {
          missingCommitsCheck = "error";
          autoStash = true;
          autoSquash = true;
        };
        rerere.enabled = true;
        gpg = {
          ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        };
        alias = {
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
    };

    home.file.".ssh/allowed_signers".text = lib.concatStringsSep "\n" allowedSignersEntries;

    home.packages = [
      (mkGitCommand "git-fixup")
    ];
  };
}
