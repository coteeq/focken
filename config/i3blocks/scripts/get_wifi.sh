#!/bin/sh

#SSID="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | head -1 | sed "s/yes://g")"
#if [[ ! -z $SSID ]]
#then
#     printf '<span color="#50B0B0">%s</span>' "$SSID"
#fi

if [[ ! -z "$(ip link show | grep enp0)" ]]
then
    if [[ ! -z "$(ip link show | grep POINTOPOINT)" ]]
    then
        printf '<span color="#00a050">%s</span>' $(ip link show | grep -Po "(wg[0-9]+)")
    else
        printf '<span color="#A0A0F0">%s</span>' $(ip link show | grep -Po "(enp0s[0-9]+u[0-9]+)")
    fi
else
    printf '<span color="#70A080">%s</span>' "down"
fi

