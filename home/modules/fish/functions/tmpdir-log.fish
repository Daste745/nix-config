set -l selected_dir (tac /tmp/tmpdir.log \
    | fzf --preview "echo {} | cut -d ' ' -f 1 | xargs ls -lah --color=always" \
          --prompt "Select temp directory " \
          --no-sort \
    | cut -d ' ' -f 1)

cd $selected_dir
