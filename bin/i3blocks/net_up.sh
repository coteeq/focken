#!/bin/sh
notify-send "Connection $1 up"
pkill -SIGRTMIN+16 i3blocks

