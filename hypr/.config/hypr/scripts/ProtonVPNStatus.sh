#!/usr/bin/env bash

status="$(protonvpn status 2>/dev/null)"

if ip link show proton0 &>/dev/null; then
    notify-send "ProtonVPN Status: Connected" "ProtonVPN is currently connected"
else
    notify-send "ProtonVPN Status: Disconnected" "ProtonVPN is currently disconnected"
fi
