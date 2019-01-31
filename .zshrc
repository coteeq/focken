export ZSH=/home/syn/.oh-my-zsh
export PATH=$PATH:~/bin

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

#fpath=( "$HOME/.zfunctions" $fpath )

plugins=(virtualenv zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ============ GIT ALIAS =============
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
# ====================================

alias vi='nvim'
alias venv='python3 -m venv'
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -l -a --sort name --git --header'
alias ssh='TERM=xterm ssh'

export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/chromium

git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%F{71}⇡NUM%f"
  local BEHIND="%{$fg[cyan]%}⇣NUM"
  local MERGING="%{$fg[magenta]%}🗲"
  local UNTRACKED="%F{245}●%f"
  local MODIFIED="%F{202}●%f"
  local STAGED="%F{191}●%f"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=("")
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "%F{255}$GIT_LOCATION%f" )
  GIT_INFO+=( '%{$reset_color%}' )
  echo "%K{23}${(j: :)GIT_INFO}%k"

}

prompt_setup_goga(){
  ZSH_THEME_VIRTUALENV_PREFIX=" "
  ZSH_THEME_VIRTUALENV_SUFFIX=" "
  base_prompt='%K{23}%F{7}$(virtualenv_prompt_info)%K{29}%F{0} %0~ %k%f'
  post_prompt=' '
  precmd_functions+=(prompt_goga_precmd)
}

prompt_goga_precmd(){
  local gitinfo=$(git_info)
  PROMPT="$base_prompt$gitinfo$post_prompt"
}

prompt_setup_goga

