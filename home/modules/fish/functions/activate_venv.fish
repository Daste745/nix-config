for venv_dir in ".venv" "venv"
    if test -d "$venv_dir" -a -f "$venv_dir/bin/activate.fish"
        echo "source $venv_dir/bin/activate.fish"
        return
    end
end

echo "# No venv found"
