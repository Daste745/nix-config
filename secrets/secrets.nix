let
  keys = import ../assets/keys.nix;
in
{
  "wakatime-cfg.age".publicKeys = [
    keys.user.nauvis
    keys.user.aquilo
  ]
}
