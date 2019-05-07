#!/bin/bash
if [[ -z "$@" ]]; then
    find ~/.config/rofi/scripts -type f -not -name "*.sh" -printf "%f\n" -maxdepth 1 | sort
else
    killall rofi
    exec "~/.config/rofi/scripts/$@"
fi

