#!/bin/bash
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = "true" ]; then

    hyprctl eval "\
        hl.config({ animations = { enabled = false } }); \
        hl.config({ decoration = { shadow = { enabled = false }, rounding = 0 } }); \
        hl.config({ general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })"

    notify-send -e -u low -i "$notif" "Semi Gamemode:" " enabled"
    exit
else
    swww-daemon &
    sleep 0.3 # wait for swww socket to be ready
    if [ -n "$orig_wall" ] && [ -f "$orig_wall" ]; then
        swww img "$orig_wall"
    fi
    sleep 0.1
    ${SCRIPTSDIR}/WallustSwww.sh "$orig_wall"
    sleep 0.5
    hyprctl reload
    ${SCRIPTSDIR}/Refresh.sh
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
hyprctl reload
