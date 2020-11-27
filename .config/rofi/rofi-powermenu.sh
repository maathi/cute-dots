#!/bin/bash


if [ -z "$@" ]; then
    echo -en "option1\n"
    echo -en "option2\n"
    echo -en "option3\n"
    echo -en "option4\n"
else
    if [ "$1" = "Shutdown" ]; then
        echo -en "Now\n30s\n1m"
    elif [ "$1" = "Logout" ]; then
        i3-msg exit
    elif [ "$1" = "Reboot" ]; then
        sudo reboot
    elif [ "$1" = "Suspend" ]; then
        systemctl suspend
    fi
fi
