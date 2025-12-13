if test -z "$argv"
    echo "Usage: forever [-q] <command>"
    return 1
end

argparse --stop-nonopt --name "forever" "q" -- $argv
or return

set verbose true
if test -n "$_flag_q"
    set verbose false
end

while true
    $verbose && echo "[forever] $argv"
    $argv
    set -l signal (fish_status_to_signal "$status")
    if test $signal = "SIGINT"
    $verbose && echo "[forever] Received SIGINT, exiting..."
    break
    end
    sleep 0.1s
end
