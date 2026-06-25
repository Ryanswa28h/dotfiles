#!/bin/bash

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
fi

# Variables
iDIR="$HOME/.config/swaync/images"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
animations_dir="$HOME/.config/hypr/animations"
configs="$HOME/.config/hypr/configs"
rofi_theme="$HOME/.config/rofi/config-Animations.rasi"
msg='❗NOTE:❗ This will copy animations into configs/Animations.lua'
# list of animation files, sorted alphabetically with numbers first
animations_list=$(find -L "$animations_dir" -maxdepth 1 -type f | sed 's/.*\///' | sed 's/\.lua$//' | sort -V)

# Rofi Menu
chosen_file=$(echo "$animations_list" | rofi -i -dmenu -config $rofi_theme -mesg "$msg")

# Check if a file was selected
if [[ -n "$chosen_file" ]]; then
  full_path="$animations_dir/$chosen_file.lua"
  cp "$full_path" "$configs/Animations.lua"
  notify-send -u low -i "$iDIR/ja.png" "$chosen_file" "Hyprland Animation Loaded"
fi

sleep 1
hyprctl reload
