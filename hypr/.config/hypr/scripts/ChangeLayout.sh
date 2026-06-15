#!/bin/bash

notif="$HOME/.config/swaync/images/arch.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

LAYOUT=$(hyprctl -j getoption general:layout | jq -r '.str')

case $LAYOUT in
"master")
	hyprctl eval "hl.config({ general = { layout = 'dwindle' } })"
	notify-send -e -u low -i "$notif" " Dwindle Layout"
	;;
"dwindle")
	hyprctl eval "hl.config({ general = { layout = 'scrolling' }, scrolling = { column_width = 0.5, fullscreen_on_one_column = true } })"
	notify-send -e -u low -i "$notif" " Scrolling Layout"
	;;
"scrolling")
	hyprctl eval "hl.config({ general = { layout = 'master' } })"
	notify-send -e -u low -i "$notif" " Master Layout"
	;;
*) ;;
esac

sleep 1
"$SCRIPTSDIR/RefreshNoWaybar.sh"
