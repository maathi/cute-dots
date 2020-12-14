#!/bin/sh

battery_print() {
    PATH_AC="/sys/class/power_supply/AC"
    PATH_BATTERY_0="/sys/class/power_supply/BAT0"
    PATH_BATTERY_1="/sys/class/power_supply/BAT1"

    ac=0
    battery_level_0=0
    battery_level_1=0
    battery_max_0=0
    battery_max_1=0

    if [ -f "$PATH_AC/online" ]; then
        ac=$(cat "$PATH_AC/online")
    fi

    if [ -f "$PATH_BATTERY_0/energy_now" ]; then
        battery_level_0=$(cat "$PATH_BATTERY_0/energy_now")
    fi

    if [ -f "$PATH_BATTERY_0/energy_full" ]; then
        battery_max_0=$(cat "$PATH_BATTERY_0/energy_full")
    fi

    if [ -f "$PATH_BATTERY_1/energy_now" ]; then
        battery_level_1=$(cat "$PATH_BATTERY_1/energy_now")
    fi

    if [ -f "$PATH_BATTERY_1/energy_full" ]; then
        battery_max_1=$(cat "$PATH_BATTERY_1/energy_full")
    fi

    battery_level=$(("$battery_level_0 + $battery_level_1"))
    battery_max=$(("$battery_max_0 + $battery_max_1"))

    battery_percent=$(("$battery_level * 100"))
    battery_percent=$(("$battery_percent / $battery_max"))

    if [ "$ac" -eq 1 ]; then
        icon="%{F#00f}%{F-}"

        if [ "$battery_percent" -gt 97 ]; then
            echo "$icon"
        else
            echo "$icon  $battery_percent %"
        fi
    else
        if [ "$battery_percent" -gt 95 ]; then
            icon="%{F#008707}%{F-}"
        elif [ "$battery_percent" -gt 80 ]; then
            icon="%{F#008707}%{F-}"
        elif [ "$battery_percent" -gt 65 ]; then
            icon="%{F#7fff00}%{F-}"
        elif [ "$battery_percent" -gt 35 ]; then
            icon="%{F#ff0}%{F-}"
        elif [ "$battery_percent" -ge 20 ]; then
            icon="%{F#ffa500}%{F-}"
        elif [ "$battery_percent" -gt 5 ]; then
            icon="%{F#f00}%{F-}"
        else
            icon="%{F#f00}%{F-}"
	        notify-send "dude.. you gonna plug me or what!?"
        fi

        echo "$icon  $battery_percent %"
    fi
}

path_pid="/tmp/polybar-battery-combined-udev.pid"

case "$1" in
    --update)
        pid=$(cat $path_pid)

        if [ "$pid" != "" ]; then
            kill -10 "$pid"
        fi
        ;;
    *)
        echo $$ > $path_pid

        trap exit INT
        trap "echo" USR1

        while true; do
            battery_print

            sleep 30 &
            wait
        done
        ;;
esac
