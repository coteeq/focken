#!/bin/sh
if [[ "$2" -eq "up" ]]
then
    bash /home/syn/bin/i3blocks/net_up.sh $1
elif [[ $2 -eq "down" ]]
then
    bash /home/syn/bin/i3blocks/net_down.sh $1    
fi

