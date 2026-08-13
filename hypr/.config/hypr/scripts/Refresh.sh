#!/bin/bash
# Scripts for refreshing Noctalia, ags, rofi, and wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes
_ps=(rofi ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

# quit ags & relaunch ags
#ags -q && ags &

# quit quickshell & relaunch quickshell
pkill qs && qs &

# some process to kill
for pid in $(pidof rofi ags swaybg); do
    kill -SIGUSR1 "$pid"
done

# Reload Noctalia after shell-related refresh work.
noctalia msg config-reload

sleep 1

exit 0