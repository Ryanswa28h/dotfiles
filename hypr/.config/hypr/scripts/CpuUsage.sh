#!/bin/bash
# Custom CPU usage for Waybar
# reads /proc/stat for accurate total CPU usage

cache=/tmp/cpu_prev_values

if [ ! -f "$cache" ]; then
    awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat > "$cache"
    echo " 0%"
    exit 0
fi

read -r prev_total prev_idle < "$cache"
read -r total idle < <(awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat)

d_total=$((total - prev_total))
d_idle=$((idle - prev_idle))
usage=$((100 * (d_total - d_idle) / d_total))

echo "$total $idle" > "$cache"
echo " ${usage}%"
