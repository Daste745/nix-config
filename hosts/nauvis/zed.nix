{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      set -euo pipefail

      if [ $# -ne 1 ]; then
        echo "Usage: zed <path>" >&2
        exit 1
      fi

      remote=$(hostname)
      path=$(readlink -f "$1")

      zed.exe ssh://$remote$path & disown $!
    '')
  ];
}
