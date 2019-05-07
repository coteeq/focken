#!/bin/sh
notify-send "power off"
pkill -SIGRTMIN+15 i3blocks

