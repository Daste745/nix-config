{
  config,
  lib,
  pkgs,
  isLinux,
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
      # `pkgs.zed-editor` only emits the `zeditor` binary, but we also add a `zed` alias
      zeditorAlias = pkgs.writeShellScriptBin "zed" ''exec ${lib.getExe pkgs.zed-editor} "$@"'';
    in
    {
      # TODO)) Change this condition to be a generic "is WSL" check.
      #        We don't need the `zed` alias and `zed-editor` package in WSL
      home.packages = lib.optionals (isLinux && !cfg.wslCompatScript.enable) [
        pkgs.zed-editor
        zeditorAlias
      ];

      xdg.configFile = {
        # FIXME)) ~/.nix-config shouldn't be hardcoded
        # FIXME)) config.home.homeDirectory is not always there
        zed.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/home/modules/zed/config";
      };
    };
}
