export ZSH=$HOME/.oh-my-zsh

plugins=(virtualenv zsh-syntax-highlighting docker docker-compose)

WORDCHARS=${WORDCHARS//\/[&.;]}

DISABLE_AUTO_UPDATE=true
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
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name'
alias lg='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name --git'
alias ssh='TERM=xterm ssh'
alias valg='valgrind --leak-check=full --track-origins=yes -v'
alias py='python3'
alias ag='rg --no-heading'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'
# }}}
[ -d $HOME/src/focken ] && source $HOME/src/focken/forgit.zsh

export EDITOR=nvim

source $HOME/.geometry.d/geometry.zsh
GEOMETRY_INFO=()
GEOMETRY_PROMPT=(geometry_echo geometry_path geometry_status)
GEOMETRY_STATUS_SYMBOL=$
GEOMETRY_STATUS_SYMBOL_ERROR=$
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

if [ -f "$HOME/.zshrc-yandex" ]; then source "$HOME/.zshrc-yandex"; fi
which zoxide > /dev/null && eval "$(zoxide init zsh)"

source "${0:A:h}/functions.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
