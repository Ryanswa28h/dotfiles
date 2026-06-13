#!/bin/bash
# 🌈 Animated rainbow borders for Hyprland

while true; do
    COLORS=()
    for i in {1..10}; do
        COLORS+=("0xff$(openssl rand -hex 3)")
    done

    hyprctl keyword general:col.active_border "${COLORS[@]}" 270deg > /dev/null
    sleep 0.5
done
