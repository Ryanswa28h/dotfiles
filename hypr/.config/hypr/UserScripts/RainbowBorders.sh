#!/bin/bash

# Convert 0xAARRGGBB to rgba(RRGGBBAA)
function to_rgba() {
    local hex="${1#0xff}"
    echo "rgba(${hex}ff)"
}

colors=(
    "0xffff0000" # Red
    "0xffff7f00" # Orange
    "0xffffff00" # Yellow
    "0xff00ff00" # Green
    "0xff0088ff" # Blue
    "0xffaa44ff" # Purple
)

# Convert to rgba format
rgba_colors=()
for c in "${colors[@]}"; do
    rgba_colors+=("$(to_rgba "$c")")
done

# Read inactive_border color from UserDecorations.lua to keep it consistent
USERDECORATIONS="$HOME/.config/hypr/UserConfigs/UserDecorations.lua"
if [ -f "$USERDECORATIONS" ]; then
    inactive_color=$(grep 'inactive_border' "$USERDECORATIONS" | grep -o 'rgba([^)]*)' | tail -1)
fi
: "${inactive_color:=rgba(292929ff)}"

# Build Lua table string for gradient
# Lua format: { colors = { "rgba(...)", "rgba(...)" }, angle = 270 }
color_list=""
for i in "${!rgba_colors[@]}"; do
    if [ "$i" -gt 0 ]; then
        color_list+=", "
    fi
    color_list+="\"${rgba_colors[$i]}\""
done
lua_config="hl.config({ general = { col = { active_border = { colors = { $color_list }, angle = 270 }, inactive_border = \"$inactive_color\" } } })"

# Apply gradient via Lua API
hyprctl eval "$lua_config"
