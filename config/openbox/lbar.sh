#!/usr/bin/env bash

PANEL_FIFO=${PANEL_FIFO:-'/tmp/lemon-pipe'}

if [ -e "${PANEL_FIFO}" ]; then 
    rm "${PANEL_FIFO}"
fi
mkfifo "${PANEL_FIFO}"

work(){
    while true; do
        local ws=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //' )
        local seq="%{T1} "
        local total=$(xprop -root _NET_NUMBER_OF_DESKTOPS | sed -e 's/_NET_NUMBER_OF_DESKTOPS(CARDINAL) = //' )

        
        for ((i=0;i<total;i++)); do
            if [[ "$i" -eq "$ws" ]]; then
                seq="${seq}%{R T2}  %{R T1}"
            else            
                seq="${seq} • "
            fi
        done
        out="WSP ${seq}%{T1}"
        printf '%s\n' "$out"
        sleep 1
    done
}

#work > "${PANEL_FIFO}" &

make_vpn(){
    vpn='tun '
    col='#404040'
    icon=''

    if [[ ! -z "$(ip link show | rg 'wg0: .*<POINTOPOINT')" ]]
    then
        icon='﫵'
        col='#dd6060'
    else
        col='#aa3030'
    fi

    echo "%{F$col}$icon%{F-}"
}

fvpn(){
    while true; do
        echo "VPN $(make_vpn)"
        sleep 10
    done
}

fvpn > "${PANEL_FIFO}" &

make_time() {
    time_=$(date +'%H:%M')
    date_=$(date +'%Y-%m-%d')

    echo "%{F#C080D0}${time_}%{F-}   %{F#A0A0C0}${date_}%{F-}"
}

ftime() 
{
    while true; do        
        echo "TIME $(make_time)"
        sleep 10
    done
}

ftime > "${PANEL_FIFO}" &

make_vol() {
    if pgrep pulseaudio > /dev/null;
    then
        vol=$(ponymix get-volume)
        if ponymix is-muted;
        then
            body=$(printf "婢 %s\n" $vol)
            color='#606060'
        else
            body=$(printf "墳 %s\n" $vol)
            color='#ff66cc'
        fi

        echo "%{F$color}$body%{F-}"
    else
        printf "vol dead"
    fi
}

fvol2() {
    while read; do
        echo REL_VOL > $PANEL_FIFO
    done
}

~/.config/bspwm/pulsen | fvol2 &

make_bat() {
    stat=$(acpi)
    perc=$(echo $stat | rg -o "([0-9]+)%" -r '$1')

    case $perc in
        [0-9]) glyph=''; color='#FF8060';;
        1[0-9]) glyph=''; color='#909060';;
        2[0-9]) glyph=''; color='#80A060';;
        3[0-9]) glyph=''; color='#70E070';;
        4[0-9]) glyph=''; color='#70E080';;
        5[0-9]) glyph=''; color='#70E080';;
        6[0-9]) glyph=''; color='#70E0A0';;
        7[0-9]) glyph=''; color='#70E0A0';;
        8[0-9]) glyph=''; color='#70E0A0';;
        9[0-9]) glyph=''; color='#70E0B0';;
        100)    glyph=''; color='#70E0B0';;
    esac

    if echo $stat | rg "Charging" > /dev/null;
    then
        glyph=''
        color='#70D0B0';
    fi

    echo "%{F$color}$glyph $perc%{F-}"
}

fbat() {
    while true; do
        echo "BAT $(make_bat)"
        sleep 60
    done
}

fbat > $PANEL_FIFO &

memory() {
    while true; do
        kb=$(cat /proc/meminfo | rg -Po 'Available: +([0-9]*)' -r '$1')
        printf "MEM %%{F#cccc77}%s%%{F-}\n" $(numfmt --from=si --to=iec "${kb}K")
        sleep 60
    done
}

memory > $PANEL_FIFO &

make_kbd() {
    layout=$(xkb-switch -p)
    echo "%{F#699aa4}$layout%{F-}"
}

fn_kbd=$(make_kbd)

while read -r line; do
    case $line in
        TIME*)
            fn_time="${line#TIME }"
            ;;
        DATE*)
            fn_date="${line#DATE }"
            ;;
        VOL*)
            fn_vol="${line#VOL }"
            ;;
        WSP*)
            fn_work="${line#WSP }"
            ;;       
        MUSIC*)
            fn_music="${line#MUSIC }"
            ;;
        VPN*)
            fn_vpn="${line#VPN }"
            ;;
        MEM*)
            fn_mem="${line#MEM } "
            ;;
        BAT*)
            fn_bat="${line#BAT } "
            ;;
        WIN*)            
            title="${line#WIN } "
            ;;
        REL_KBD*)
            fn_kbd="$(make_kbd)"
            ;;
        REL_VOL*)
            fn_vol="$(make_vol)"
            ;;
        REL_VPN*)
            fn_vpn="$(make_vpn)"
            ;;
        REL_BAT*)
            fn_bat="$(make_bat)"

    esac
    #notify-send line "${line}"
    sep="%{F#404040}•%{F-}"
    printf "%s\n" "%{l}${fn_work}${title}%{c}${fn_music}%{r}${fn_mem} $sep ${fn_vpn} $sep ${fn_kbd} $sep ${fn_vol} $sep ${fn_time} $sep ${fn_bat} "
done < "${PANEL_FIFO}" | lemonbar -f "Iosevka Burnt:size=14" -f "Iosevka Nerd Font:size=14" -B '#12151a' -b | sh > /dev/null

