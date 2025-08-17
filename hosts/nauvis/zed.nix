{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
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
    '')
  ];
}
