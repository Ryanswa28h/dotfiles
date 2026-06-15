#!/bin/bash
# Toggle rainbow borders on/off - persists across hyprctl reload

notif="$HOME/.config/swaync/images/arch.png"
DECO_FILE="$HOME/.config/hypr/UserConfigs/UserDecorations.lua"

# Get current active border from hyprctl (runtime state)
current=$(hyprctl getoption general:col.active_border -j | jq -r '.gradient')
tokens=($current)
num_colors=$(( ${#tokens[@]} - 1 ))  # subtract angle token

if [ "$num_colors" -gt 1 ]; then
    # Currently rainbow → write solid color to file and reload
    notify-send -e -u low -i "$notif" "🌈 Rainbow Borders: OFF"
    DECO_FILE="$DECO_FILE" python3 << 'PYEOF'
import os

fpath = os.environ['DECO_FILE']
with open(fpath, 'r') as f:
    content = f.read()

gradient_block = '''			active_border = {
				colors = {
					"rgba(ff0000ff)",
					"rgba(ff7f00ff)",
					"rgba(ffff00ff)",
					"rgba(00ff00ff)",
					"rgba(0088ffff)",
					"rgba(aa44ffff)",
				},
				angle = 270,
			},'''

solid_line = '''			active_border = "rgba(75F1FAff)",'''

content = content.replace(gradient_block, solid_line)

with open(fpath, 'w') as f:
    f.write(content)
PYEOF
else
    # Currently solid → write gradient to file and reload
    notify-send -e -u low -i "$notif" "🌈 Rainbow Borders: ON"
    DECO_FILE="$DECO_FILE" python3 << 'PYEOF'
import os

fpath = os.environ['DECO_FILE']
with open(fpath, 'r') as f:
    content = f.read()

gradient_block = '''			active_border = {
				colors = {
					"rgba(ff0000ff)",
					"rgba(ff7f00ff)",
					"rgba(ffff00ff)",
					"rgba(00ff00ff)",
					"rgba(0088ffff)",
					"rgba(aa44ffff)",
				},
				angle = 270,
			},'''

solid_line = '''			active_border = "rgba(75F1FAff)",'''

content = content.replace(solid_line, gradient_block)

with open(fpath, 'w') as f:
    f.write(content)
PYEOF
fi

# Reload to apply the file change
hyprctl reload
