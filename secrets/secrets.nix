let
  keys = import ../assets/keys.nix;
in
{
  "wakatime-cfg.age".publicKeys = [
    keys.bootstrap
    keys.user.nauvis
    keys.user.aquilo
    keys.user.gleba
    keys.user.thinkpad
  ];
  "atuin-key.age".publicKeys = [
    keys.bootstrap
    keys.user.nauvis
    keys.user.aquilo
    keys.user.gleba
    keys.user.thinkpad
  ];
}
