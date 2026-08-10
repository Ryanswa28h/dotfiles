#!/bin/bash
# Toggle SearXNG docker stack (searxng + caddy + redis + dnsproxy).
# Usage: SearXNGToggle.sh         # toggle on/off
#        SearXNGToggle.sh on       # force start
#        SearXNGToggle.sh off      # force stop
#        SearXNGToggle.sh status   # show current state

DIR="/home/ryan/searxng-docker"
cd "$DIR" || {
    echo "error: cannot cd to $DIR" >&2
    exit 1
}

is_up() {
    [ -n "$(docker compose ps -q 2>/dev/null)" ]
}

start() {
    if is_up; then
        echo "searxng: already running"
    else
        docker compose up -d
        echo "searxng: started"
        notify-send -u low "SearXNG" "started"
    fi
}

stop() {
    if is_up; then
        docker compose down
        echo "searxng: stopped"
        notify-send -u low "SearXNG" "stopped"
    else
        echo "searxng: already stopped"
    fi
}

case "${1:-toggle}" in
on) start ;;
off) stop ;;
status)
    if is_up; then echo "searxng: UP"; else echo "searxng: DOWN"; fi
    ;;
toggle)
    if is_up; then stop; else start; fi
    ;;
*)
    echo "usage: SearXNGToggle.sh [on|off|status]" >&2
    exit 2
    ;;
esac
