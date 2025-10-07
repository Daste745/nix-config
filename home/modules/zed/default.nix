{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.zed;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.modules.zed = {
    wslCompatScript.enable = lib.mkEnableOption "zed WSL compatibility";
  };

  config =
    let
      # `pkgs.zed-editor` only emits the `zeditor` binary, but we also want an `zed`
      zeditorAlias = pkgs.writeShellScriptBin "zed" (lib.getExe pkgs.zed-editor);
      wslCompatScript = pkgs.writeShellScriptBin "zed" ''
        set -euo pipefail

        # zed: Open a file in Zed editor on Windows using SSH remote
        # Requires a non-development version of Zed to be in Windows' PATH

        if [ $# -ne 1 ]; then
          echo "Usage: zed <path>" >&2
          exit 1
        fi

        remote=$(hostname)
        path=$(readlink -f "$1")

        zed.exe ssh://$remote$path & disown $!
      '';
    in
    {
      home.packages =
        (lib.optionals (pkgs.stdenv.hostPlatform.isLinux && !cfg.wslCompatScript.enable) [
          pkgs.zed-editor
          zeditorAlias
        ])
        ++ (lib.optionals cfg.wslCompatScript.enable [
          wslCompatScript
        ]);

      xdg.configFile = {
        # FIXME)) ~/.nix-config shouldn't be hardcoded
        # FIXME)) config.home.homeDirectory is not always there
        zed.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/home/modules/zed/config";
      };
    };
}
