#!/bin/bash
# 🌈 Animated rainbow borders for Hyprland

while true; do
    COLORS=()
    for i in {1..10}; do
        hex=$(openssl rand -hex 3)
        COLORS+=("rgba(${hex}ff)")
    done

    # Build Lua table string for gradient
    color_list=""
    for i in "${!COLORS[@]}"; do
        if [ "$i" -gt 0 ]; then
            color_list+=", "
        fi
        color_list+="\"${COLORS[$i]}\""
    done
    lua_config="hl.config({ general = { col = { active_border = { colors = { $color_list }, angle = 270 } } } })"

    hyprctl eval "$lua_config" > /dev/null
    sleep 0.5
done
