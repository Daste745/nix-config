let
  keys = import ../assets/keys.nix;
in
{
  "wakatime-cfg.age".publicKeys = [
    keys.bootstrap
    keys.user.nauvis
    keys.user.aquilo
  ];
}
