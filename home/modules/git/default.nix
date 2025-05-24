{ pkgs, ... }:
let
  mkGitCommand =
    name: pkgs.writeShellScriptBin name (builtins.readFile ./commands/${name});
in
{
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

  home.packages = [
    (mkGitCommand "git-fixup")
  ];
}
