{ pkgs, isLinux, ... }:
let
  profilesPath = "/nix/var/nix/profiles/";
  previewWrapper = pkgs.writeShellScriptBin "preview-wrapper" (
    if isLinux then "script -eq -c \"dix $@\" /dev/null" else "script -q /dev/null dix $@"
  );
  preview = pkgs.writeShellScriptBin "preview" ''
    # {+f} from fzf is passed as an argument to this script
    cat $1 \
      | sort -t '-' -k 2 -n \
      | awk '{print "${profilesPath}" $1}' \
      | tr \\n ' ' \
      | xargs preview-wrapper
  '';
in
{
  home.packages = with pkgs; [
    dix
    (pkgs.writeShellApplication {
      name = "dix-fzf";
      runtimeInputs = [
        fzf
        dix
        preview
        previewWrapper
      ];
      text = ''
        # TODO: This is a mess, clean it up at some point :^)
        find ${profilesPath} -maxdepth 1 -type l \
          | cut -d '/' -f 6 \
          | sort -t '-' -k 2 -n -r \
          | fzf --multi 2 \
                --prompt "Select 2 systems to compare " \
                --preview-window=right,80% \
                --preview "preview {+f}" \
          | sort -t '-' -k 2 -n \
          | awk "{print \"${profilesPath}\" \$1}" \
          | tr \\n ' ' \
          | xargs dix
      '';
    })
  ];
}
