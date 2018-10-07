#!/bin/bash
if [[ -z "$@" ]]; then
    find ~/bin/rofi -type f -not -name "*.sh" -printf "%f\n" -maxdepth 1 | sort
else
    killall rofi
    exec "~/bin/rofi/$@"
fi

