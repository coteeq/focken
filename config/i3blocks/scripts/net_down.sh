#!/bin/sh
notify-send "Connection $1 down"
pkill -SIGRTMIN+16 i3blocks

