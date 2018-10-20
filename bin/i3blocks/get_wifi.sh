#!/bin/sh
SSID="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | head -1 | sed "s/yes://g")"
if [[ ! -z "$(ip link show | grep wg0)" ]]
then
    printf '<span color="#00a000">%s</span> - ' "WG"
else
    printf '<span color="#F030F0">%s</span> - ' "PT"
fi
if [[ ! -z "$(ip link show | grep "enp0s20u[0-9]")" ]]
then
    printf '<span color="#A0A0F0">%s</span>' `ip link show | grep -Po "enp[0-9]s[0-9]+u\K([0-9]+)"`
elif [[ ! -z $SSID ]]
then
    printf '<span color="#50B0B0">%s</span>' "$SSID"
else
    echo 'down'
fi

