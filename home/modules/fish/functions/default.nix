let
  mkFunction = name: builtins.readFile ./${name}.fish;
in
{
  activate_venv = mkFunction "activate_venv";
  forever = mkFunction "forever";
  tmpdir = mkFunction "tmpdir";
  tmpdir-log = mkFunction "tmpdir-log";
}
