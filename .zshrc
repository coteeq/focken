export ZSH=/home/syn/.oh-my-zsh

#fpath=( "$HOME/.zfunctions" $fpath )

plugins=(virtualenv zsh-syntax-highlighting docker docker-compose)

source $ZSH/oh-my-zsh.sh

# alias {{{
# ============ GIT =============
alias g='git'
alias gg='git status'
alias gh='git checkout'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gr='git remote'
alias gb='git branch'
alias gc='git commit'
alias ga='git add'
alias gba='git branch --all -vvv'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gloga="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
# ==============================

alias v='nvim'
alias venv='python3 -m venv'
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name --git'
alias ssh='TERM=xterm ssh'
alias dcoker='docker' # I really have no fucking idea, why I misspell it like this
alias valg='valgrind --leak-check=full --track-origins=yes -v'
alias py='python'
function prg {
    ps aux | rg $1
}
function vkill {
    kill $(ps aux | fzf -m | awk '{print $2}')
}
alias feh='feh --font "iosevka-burnt-regular/24" -C ~/.fonts/ --menu-font "iosevka-burnt-regular/24"'
# }}}

export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/chromium

source $HOME/.geometry.d/geometry.zsh
GEOMETRY_INFO=()
GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path)
GEOMETRY_STATUS_SYMBOL=喝
GEOMETRY_STATUS_SYMBOL_ERROR=喝
GEOMETRY_STATUS_COLOR=3

# colored man {{{

function man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;36m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;91m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		_NROFF_U=1 \
			man "$@"
        }
# }}}

