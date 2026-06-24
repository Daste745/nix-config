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
  pythonStartup = "${configHome}/python/startup.py";
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
    PYTHONSTARTUP = pythonStartup; # Python <= 3.12
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

  home.file."${pythonStartup}".text = ''
    import atexit
    import os
    import readline

    MAX_HISTORY_LEN = 10_000

    # Use PYTHON_HISTORY env from Python>=3.13
    if "PYTHON_HISTORY" in os.environ:
        histfile = os.path.expanduser(os.environ["PYTHON_HISTORY"])
    # Or just use ~/.local/state/python_history
    elif "XDG_STATE_HOME" in os.environ:
        histfile = os.path.join(os.path.expanduser(os.environ["XDG_STATE_HOME"]), "python_history")
    # Fall back to ~/.python_history
    else:
        histfile = os.path.join(os.path.expanduser("~"), ".python_history")

    # From https://docs.python.org/3/library/readline.html#example
    # Supports concurrent interactive sessions merging their history at exit
    try:
        readline.read_history_file(histfile)
        history_len = readline.get_current_history_length()
    except FileNotFoundError:
        open(histfile, "wb").close()
        history_len = 0

    def save_history(prev_history_len, histfile):
        new_history_len = readline.get_current_history_length()
        readline.set_history_length(MAX_HISTORY_LEN)
        readline.append_history_file(new_history_len - prev_history_len, histfile)

    atexit.register(save_history, history_len, histfile)
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
    cache-min: 604800  # seconds (7 days)
    ignore-scripts: true
    disable-self-update-check: true
  '';

  home.file."${configHome}/uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';
}
