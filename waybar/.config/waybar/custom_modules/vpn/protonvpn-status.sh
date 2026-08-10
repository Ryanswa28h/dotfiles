#!/usr/bin/env bash

status="$(protonvpn status 2>/dev/null)"

if ip link show proton0 &>/dev/null; then
    echo '{"text":"󰖂 VPN","class":"connected","tooltip":"Proton VPN connected"}'
else
    echo '{"text":"󰖂 VPN","class":"disconnected","tooltip":"Proton VPN disconnected"}'
fi
