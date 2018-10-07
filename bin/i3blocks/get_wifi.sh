#!/bin/sh
SSID="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | head -1 | sed "s/yes://g")"
if [[ ! -z "$(ip link show | grep "enp0s20u[0-9]")" ]]
then
    printf '<span color="#F06060">%s</span>' `ip link show | grep -Po "enp[0-9]s[0-9]+\K(u[0-9]+)"`
elif [[ ! -z $SSID ]]
then
    printf '<span color="#50B0B0">%s</span>' "$SSID"
else
    echo 'NETDOWN'
fi

