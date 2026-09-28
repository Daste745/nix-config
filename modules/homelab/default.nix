{ lib, ... }:
{
  options.homelab = {
    # NOTE: `services.<name>` is reserved to service-defined options
    dashboard.services = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            title = lib.mkOption {
              type = lib.types.str;
              description = "Dashboard title";
              example = "Immich";
            };
            description = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Dashboard description";
              example = "Photo library";
            };
            category = lib.mkOption {
              type = lib.types.str;
              description = "Dashboard category";
              example = "Media";
            };
            icon = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Dashboard icon";
              example = "di:immich";
            };
            url = lib.mkOption {
              type = lib.types.str;
              description = "Service URL";
              example = "immich.domain.com";
            };
          };
        }
      );
    };
  };

  imports = [
    ./services
    ./proxy.nix
  ];
}

# References:
# https://git.poz.pet/poz/niksos/src/branch/main/hosts/szparag/services/immich.nix
# https://git.notthebe.ee/notthebee/nix-config/src/branch/main/modules/homelab/services/jellyfin/default.nix
# https://git.notthebe.ee/notthebee/nix-config/src/branch/main/modules/homelab/services/homepage/default.nix
#
# Docs:
# https://ryantm.github.io/nixpkgs/functions/library/options/
# https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html
