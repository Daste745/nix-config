let
  keys = import ../assets/ssh.nix;
in
{
  "wakatime-cfg.age".publicKeys = [
    keys.users.nauvis
    keys.users.aquilo
  ]
}
