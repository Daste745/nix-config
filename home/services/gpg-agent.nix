{ config, lib, ... }:
let
  cfg = config.services.gpg-agent;
in
{
  options = {
    services.gpg-agent = {
      pinentryProgramPath = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = ''
          Custom path to the pinentry program used by gpg-agent.
          On WSL, this is usually located in
          "/mnt/c/Program Files (x86)/Gpg4win/bin/pinentry.exe".
        '';
      };
    };
  };

  config =
    let
      pinentryProgramExtraConfig =
        if cfg.pinentryProgramPath != null then
          [ "pinentry-program = ${cfg.pinentryProgramPath}\n" ]
        else
          [ ];
      extraConfigParts = [
        # Space for non-conditional config
      ] ++ pinentryProgramExtraConfig;
    in
    {
      services.gpg-agent = {
        enable = true;
        enableFishIntegration = true;
        extraConfig = lib.concatStringsSep "\n" extraConfigParts;
      };
    };
}
