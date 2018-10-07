#!/bin/bash


# Names of monitors (given by xrandr)
INT="eDP-1"
EXT="HDMI1"


# Create mode & put it to xrandr
xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
xrandr --addmode $INT 1920x1080_60.00

# Create 1600x900 module
xrandr --newmode "1600x900_60.00"  119.00  1600 1696 1864 2128  900 901 904 932  -HSync +Vsync
xrandr --addmode $INT 1600x900_60.00

xrandr --output $INT --mode 1920x1080_60.00

