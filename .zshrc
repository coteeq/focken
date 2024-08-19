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

alias v='nvim'
alias venv='python3 -m venv'
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name'
alias ssh='TERM=xterm ssh'
alias valg='valgrind --leak-check=full --track-origins=yes -v'
alias py='python3'
alias ag='rg --no-heading'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'
# }}}

# [ -d $HOME/src/focken ] && source $HOME/src/focken/forgit.zsh

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

source $HOME/.geometry.d/geometry.zsh
GEOMETRY_INFO=()
GEOMETRY_PROMPT=(geometry_echo geometry_path geometry_status)
GEOMETRY_STATUS_SYMBOL=$
GEOMETRY_STATUS_SYMBOL_ERROR=$
GEOMETRY_STATUS_COLOR=3

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#308888"

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
