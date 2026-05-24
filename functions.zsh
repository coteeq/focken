function get_ps {
    ps -eo 'user,pid,ppid,pcpu,pmem,vsz,stat,time,args'
}

function prg {
    [[ "1" -gt "$#" ]] && return;
    get_ps | rg "$@"
}

function vkill {
    pids="$(get_ps | fzf -m | awk '{print $2}')"
    [[ -n "$pids" ]] && kill $(echo "$pids" | tr '\n' ' ') && return
    echo "no procs"
}

function shadow {
    ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" $@
}

function shadowcopy {
    scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" $@
}

# shoot = shadow root
function shoot {
    ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -l root $@
}

# choot = copy shadow root
function choot {
    scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@$@
}

# --- YT ---

function find_proto() {
    msg="$1"
    if [ -z "$path" ]; then
        echo "need name"
        exit 1
    fi
    pattern="message $msg"
    ya tool cs "$pattern" --file='^yt' -l -t \
        | fzf --preview="rg -C 15 \"$pattern\" $(arc root)/{}" \
        | xargs -I% bash -c "code -g \$(arc root)/%:\$(rg -n \"$pattern\" \$(arc root)/% | head -1 | cut -d: -f1)"
}

function arcage() {
    arc log --json -n 1 | jq -r '.[0].date'
}

function pr() {
    if [ $# -lt 1 ];
    then
        arc pr status -s
    elif [ "sel" = "$1" ]
    then
        arc pr select
    else
        arc pr $@
    fi
}

function unwrap_logs() {
    fd -L '\.zst$' | xargs -P 16 -I{} bash -c 'zstdcat {} | sed "s/\\\n/\n/g" > $(x="{}"; echo ${x%.log.zst}).nlog'
    #                           This shit substitutes '.log.zst' with '.nlog'   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
}

function loc() {
	curl -sS https://1.1.1.1/cdn-cgi/trace | grep -E -- '(loc|colo)='
}

function sssh() {
    local stty_saved response
    stty_saved=$(stty -g)

    ssh "$@"

    # Disable mouse events
    printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l'

    # Query alt screen state (DECRQM)
    stty "$stty_saved" 2>/dev/null
    stty -echo raw min 0 time 1
    printf '\e[?1049$p'
    IFS= read -r -d 'y' response
    stty "$stty_saved"

    # Exit alt screen only if active (1$y is active, 2$y is non-active)
    local pattern='\?1049;1\$'
    if [[ "$response" =~ $pattern ]]; then
      tput rmcup
    fi
}
