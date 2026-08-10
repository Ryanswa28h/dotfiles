#!/usr/bin/env bash

if protonvpn status 2>/dev/null | grep -q '^Status: Connected'; then
    notify-send -u low "ProtonVPN" "Disconnecting"
    protonvpn disconnect
    notify-send -u low "ProtonVPN" "Successfully Disconnected"
else
    notify-send -u low "ProtonVPN" "Connecting"
    protonvpn connect
    notify-send -u low "ProtonVPN" "Successfully Connected"
fi

pkill -RTMIN+8 waybar
