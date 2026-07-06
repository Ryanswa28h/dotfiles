#!/usr/bin/env bash

STATE_FILE="/tmp/autoclicker.running"
PID_FILE="/tmp/autoclicker.pid"

start() {
    # already running check
    if [ -f "$STATE_FILE" ]; then
        notify-send "Autoclicker already brrrrr"
        exit 0
    fi

    notify-send "Autoclicker go brrrrr"

    echo "1" >"$STATE_FILE"

    (
        while [ -f "$STATE_FILE" ]; do
            YDOTOOL_SOCKET=/run/user/1000/.ydotool_socket ydotool click 0xC0
            sleep 0.02
        done
    ) &

    echo $! >"$PID_FILE"
}

stop() {
    notify-send "Autoclicker go stop"

    rm -f "$STATE_FILE"

    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
    fi
}

toggle() {
    if [ -f "$STATE_FILE" ]; then
        stop
    else
        start
    fi
}

case "$1" in
start) start ;;
stop) stop ;;
toggle) toggle ;;
esac
