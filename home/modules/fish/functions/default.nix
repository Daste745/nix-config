let
  mkFunction = name: builtins.readFile ./${name}.fish;
in
{
  tmpdir = mkFunction "tmpdir";
  forever = mkFunction "forever";
  activate_venv = mkFunction "activate_venv";
}
