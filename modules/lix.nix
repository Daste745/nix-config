# https://lix.systems/add-to-config/#advanced-change
{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      extra-deprecated-features = [
        # warning: using or as an identifier is deprecated because it cannot be used in most places (try let or = 1; in or).
        "or-as-identifier"
      ];
    };
  };
}
