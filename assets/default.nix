{ lib, ... }:
{
  options.assets = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
  };

  config.assets = {
    keys = import ./keys.nix;
  };
}
