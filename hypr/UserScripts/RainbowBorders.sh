#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for rainbow borders animation

function random_hex() {
    random_hex=("0xff$(openssl rand -hex 3)")
    echo $random_hex
}

colors=(
    "0xff0076d1"  # Arch Blue (original Arch hue)
    "0xff005b9e"  # Darker Arch blue
    "0xff004b82"  # Deepened blue tone
    "0xff006b6b"  # Balanced teal transition
    "0xff008b5a"  # Dark cyan-green accent
)

# rainbow colors
#hyprctl keyword general:col.active_border $(random_hex)  $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex)  270deg
#hyprctl keyword general:col.inactive_border $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) $(random_hex) 270deg

# Apply gradient
#hyprctl keyword general:col.active_border ${colors[*]} 270deg
#hyprctl keyword general:col.inactive_border ${colors[*]} 270deg
