argparse --stop-nonopt --name "tmpdir" "flake" -- $argv
or return

set -l new_dir (mktemp -d /tmp/XXXXXXX)

echo -e "$new_dir $(date -Iseconds)" >> /tmp/tmpdir.log

cd $new_dir

if test -n "$_flag_flake"
    nix flake init
end
