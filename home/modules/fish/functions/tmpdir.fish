set -l new_dir (mktemp -d /tmp/XXXXXXX)

echo -e "$new_dir $(date -Iseconds)" >> /tmp/tmpdir.log

cd $new_dir
