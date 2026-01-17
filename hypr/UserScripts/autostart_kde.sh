#!/usr/bin/env bash
# Ensure D-Bus knows about our session variables
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Kill any existing kdeconnectd (to avoid duplicates)
pkill -x kdeconnectd 2>/dev/null

# Start kdeconnectd in background
kdeconnectd --replace &

# Optional: test notification
notify-send "KDE Connect" "Integration with swaync initialized!"
