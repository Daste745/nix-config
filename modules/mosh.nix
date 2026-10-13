{
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
{
  # NOTE: Darwin doesn't have `programs.mosh`
  programs.mosh = lib.mkIf isLinux {
    enable = true;
  };

  environment.systemPackages = lib.mkIf isDarwin [
    pkgs.mosh
  ];
}
