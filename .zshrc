WORDCHARS=''

# FOCKEN_DIR="$(realpath ${0:A:h})"
FOCKEN_DIR="$HOME/src/focken"
source "$FOCKEN_DIR/functions.zsh"
for bone in ${FOCKEN_DIR}/omz-bones/*.zsh; do
	source "$bone"
done
source ~/.omz-bones/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.omz-bones/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ ! "$PATH" == *$HOME/.local/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.local/bin"
fi

# alias {{{
# ============ GIT =============
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gloga="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
# ==============================

alias venv='python3 -m venv'
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name'
alias ssh='TERM=xterm ssh'
alias valg='valgrind --leak-check=full --track-origins=yes -v'
alias py='python3'
alias ag='rg --no-heading'
# }}}

# [ -d $HOME/src/focken ] && source $HOME/src/focken/forgit.zsh

export EDITOR=hx
export VISUAL=hx
export PAGER='less -FR'
export ARC_PAGER='less -FR -+X'
export ARC_EDITOR='hx'

source $HOME/.geometry.d/geometry.zsh

function yt_proxy() {
    if [ -v YT_PROXY ]; then
        echo "($YT_PROXY)"
    fi
}

GEOMETRY_INFO=()
GEOMETRY_PROMPT=(geometry_echo geometry_path yt_proxy geometry_status)
if [ "$(hostname)" = "coteeq-os" ]; then
    GEOMETRY_STATUS_SYMBOL="¢"
    GEOMETRY_STATUS_SYMBOL_ERROR="¢"
else
    GEOMETRY_STATUS_SYMBOL="$"
    GEOMETRY_STATUS_SYMBOL_ERROR="$"
fi
GEOMETRY_STATUS_COLOR=3

export BAT_STYLE=snip
export BAT_PAGING=never

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#308888"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d ~/.fzf/shell ] && source ~/.fzf/shell/key-bindings.zsh

FOCKEN_SUBLIME_DIR="/Applications/Sublime Text.app/Contents/SharedSupport/bin"
[ -d "$FOCKEN_SUBLIME_DIR" ] && export PATH="$PATH:$FOCKEN_SUBLIME_DIR"
