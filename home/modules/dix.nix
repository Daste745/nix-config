{ pkgs, ... }:
let
  profilesPath = "/nix/var/nix/profiles/";
  # NOTE: `\\\\\\\` resolves to `\\\`, because we're 2 levels deep in string literals
  _previewCommand = "cat {+f} | sort -t '-' -k 2 -n | awk '{print \\\\\\\"${profilesPath}\\\\\\\" \\\\\\\$1}' | tr \\n ' ' | xargs dix";
  previewCommand =
    if pkgs.stdenv.hostPlatform.isLinux then
      "script -eq -c \\\"${_previewCommand}\\\" /dev/null"
    else
      # TODO: Use `script` on MacOS for colored preview
      _previewCommand;
in
{
  home.packages = with pkgs; [
    dix
    (pkgs.writeShellScriptBin "dix-fzf" ''
      # TODO: This is a mess, clean it up at some point :^)
      find ${profilesPath} -maxdepth 1 -type l \
        | cut -d '/' -f 6 \
        | sort -t '-' -k 2 -n -r \
        | fzf --multi 2 \
              --prompt "Select 2 systems to compare " \
              --preview-window=right,80% \
              --preview "${previewCommand}" \
        | sort -t '-' -k 2 -n \
        | awk "{print \"${profilesPath}\" \$1}" \
        | tr \\n ' ' \
        | xargs dix
    '')
  ];
}
