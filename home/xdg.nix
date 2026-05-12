{ config, ... }:
let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;
  wgetrc = "${configHome}/wgetrc";
  npmrc = "${configHome}/npm/npmrc";
in
{
  xdg.enable = true;

  # https://wiki.archlinux.org/title/XDG_Base_Directory
  home.sessionVariables = {
    HISTFILE = "${stateHome}/bash_history";
    LESSHISTFILE = "${stateHome}/lesshst";
    WGETRC = wgetrc; # Because wget history location can't be configured via env
    NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = npmrc;
    BUN_INSTALL = "${dataHome}/bun";
    PYTHON_HISTORY = "${stateHome}/python_history"; # Python >= 3.13
    CARGO_HOME = "${dataHome}/cargo";
    DOCKER_CONFIG = "${configHome}/docker";
    GRADLE_USER_HOME = "${dataHome}/gradle";
    WAKATIME_HOME = "${configHome}/wakatime";
    SQLITE_HISTORY = "${stateHome}/sqlite_history";
    PSQL_HISTORY = "${stateHome}/psql_history";
    MYSQL_HISTFILE = "${dataHome}/mysql_history";
    REDISCLI_HISTFILE = "${dataHome}/redis/rediscli_history";
    REDISCLI_RCFILE = "${configHome}/redis/rediscli";
  };

  home.file."${wgetrc}".text = ''
    hsts-file = ${cacheHome}/wget-hsts
  '';

  home.file."${npmrc}".text = ''
    prefix=${dataHome}/npm
    cache=${cacheHome}/npm
    logs-dir=${stateHome}/npm/logs
    min-release-age=7
    ignore-scripts=true
  '';

  home.file."${configHome}/pnpm/rc".text = ''
    minimum-release-age=10080  # minutes (7 days)
    # Package build scripts are disabled by default
  '';

  home.file."${configHome}/.bunfig.toml".text = ''
    [install]
    minimumReleaseAge = 604800  # seconds (7 days)
    ignoreScripts = true
  '';

  home.file.".yarnrc".text = ''
    npmMinimalAgeGate: 7d
    enableScripts: false
  '';

  home.file."${configHome}/uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';
}
