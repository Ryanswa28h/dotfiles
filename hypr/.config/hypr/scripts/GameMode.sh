#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
WALLPAPER_SAVE="/tmp/gamemode-wallpaper.txt"

if [ "$HYPRGAMEMODE" = "true" ] ; then
    # Save current wallpaper from swww before we change it
    orig_wall=$(swww query 2>/dev/null | grep "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" | awk '{print $NF}')
    if [ -z "$orig_wall" ]; then
        orig_wall=$(readlink -f "$HOME/.config/rofi/.current_wallpaper" 2>/dev/null || echo "")
    fi
    echo "${orig_wall:-}" > "$WALLPAPER_SAVE"

    hyprctl eval "\
        hl.config({ animations = { enabled = false } }); \
        hl.config({ decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 } }); \
        hl.config({ general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })"

    # Set black wallpaper before killing swww
    magick -size 1x1 xc:black /tmp/gamemode-black.png
    swww img /tmp/gamemode-black.png --transition-step 1
    sleep 0.1
    swww kill
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    exit
else
    # Restore original wallpaper from saved path
    if [ -f "$WALLPAPER_SAVE" ]; then
        orig_wall="$(cat "$WALLPAPER_SAVE")"
    else
        orig_wall="$HOME/.config/rofi/.current_wallpaper"
    fi

    swww-daemon &
    sleep 0.3  # wait for swww socket to be ready
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
