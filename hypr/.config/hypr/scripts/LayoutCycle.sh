#!/usr/bin/env bash
# Layout-aware J/K navigation
# - In scrolling layout: move between columns (move +col / move -col)
# - In master/dwindle: cycle through windows (cyclenext)

DIRECTION="$1"

LAYOUT=$(hyprctl -j getoption general:layout | jq -r '.str')

if [ "$LAYOUT" = "scrolling" ]; then
    if [ "$DIRECTION" = "prev" ]; then
        hyprctl dispatch 'hl.dsp.layout("move -col")'
    else
        hyprctl dispatch 'hl.dsp.layout("move +col")'
    fi
else
    if [ "$DIRECTION" = "prev" ]; then
        hyprctl dispatch 'hl.dsp.window.cycle_next("prev")'
    else
        hyprctl dispatch 'hl.dsp.window.cycle_next()'
    fi
fi
