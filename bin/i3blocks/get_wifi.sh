#!/bin/sh
SSID="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | head -1 | sed "s/yes://g")"
if [[ ! -z "$(ip link show | grep POINTOPOINT)" ]]
then
    printf '<span color="#00a050">%s</span>' $(ip link show | grep -Po "(wg[0-9]+)")
else
    if [[ ! -z "$(ip link show | grep "enp0s20u[0-9]")" ]]
    then
        printf '<span color="#A0A0F0">%s</span>' `ip link show | grep -Po "(enp[0-9]s[0-9]+u[0-9]+)"`
    elif [[ ! -z $SSID ]]
    then
        printf '<span color="#50B0B0">%s</span>' "$SSID"
    else
        printf '<span color="#70A080">%s</span>' "down"
    fi
fi

