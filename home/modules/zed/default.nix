{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  config =
    let
      # `pkgs.zed-editor` only emits the `zeditor` binary, but we also add a `zed` alias
      zeditorAlias = pkgs.writeShellScriptBin "zed" ''exec ${lib.getExe pkgs.zed-editor} "$@"'';
      # Wrapper around `GIT_EDITOR="zed --wait"` to fix retained COMMIT_EDITMSG file contents bug
      # Opening a new file forces zed to load its contents from disk, mitigating the bug.
      # TODO)) Remove once https://github.com/zed-industries/zed/issues/29669 is fixed
      zedGitEditor = pkgs.writeShellApplication {
        name = "zed-git-editor";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          # `basename "$1"` extracts `COMMIT_EDITMSG` or `git-rebase-todo` from the original file path
          tmp=$(mktemp "/tmp/$(basename "$1").XXXXXX")
          cp "$1" "$tmp"

          # Block until the file is closed + open in current window
          zed --wait --existing "$tmp"

          cp "$tmp" "$1"
          rm "$tmp"
        '';
      };

      commonPackages = [ zedGitEditor ];
      # TODO)) Change this condition to be a generic "is WSL" check.
      #        We don't need the `zed` alias and `zed-editor` package in WSL
      isLinuxDesktop = isLinux && config.graphical.enable;
      linuxDesktopPackages = [
        pkgs.zed-editor
        zeditorAlias
      ];
    in
    # TODO)) Move config to graphical or split in a smarter way,
    #        so non-desktop systems don't install any zed-related packages,
    #        and WSL can get the bare minimum to run zed from Windows
    {
      home.packages = commonPackages ++ (lib.optionals isLinuxDesktop linuxDesktopPackages);

      xdg.configFile = {
        # FIXME)) ~/.nix-config shouldn't be hardcoded
        # FIXME)) config.home.homeDirectory is not always there
        zed.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/home/modules/zed/config";
      };
    };
}
