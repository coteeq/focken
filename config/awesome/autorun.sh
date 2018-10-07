#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run xfce4-power-manager
run nm-applet
run compton --unredir-if-possible
run pa-applet
run light-locker
#run syndaemon -i 1.0 -K -d
run joxi
run ~/bin/rofi/keyboard
run ~/bin/rofi/touchpad 
run betterlockscreen --wall

sh "~/bin/rofi/disable touchscreen"

