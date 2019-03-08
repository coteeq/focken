#!/bin/bash

m=256
cols() {
    for ((i=0;i<m;i++)); do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n";
        fi
    done
}

onecol() {
    printf "\x1b[48;5;%sm" $1
    printf "\t\t%10s\n" " "
    printf "\t\t%3s%3d%4s\n" " " $1 " "
    printf "\t\t%10s\n" " "
}

if [[ "$#" -le "1" ]]
then
    cols && exit
fi

case $1 in
    "-16")
        m=16;;
    "-256")
        m=256;;
    *)
        onecol $1 && exit;;
esac
cols
