export ZSH=/home/syn/.oh-my-zsh
export PATH=$PATH:~/bin:~/.local/bin

#ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

fpath=( "$HOME/.zfunctions" $fpath )

plugins=(virtualenv zsh-syntax-highlighting git)

source $ZSH/oh-my-zsh.sh

alias vi='nvim'
alias g='git'
alias gg='git status'
alias gh='git checkout'
alias fls='source ~/envs/flask/bin/activate'
alias nb='jupyter notebook'
alias ml='cd ~/code/ml && source ~/envs/ml/bin/activate && jupyter notebook --no-browser'
alias dotf='/usr/bin/git --git-dir="$HOME/dotfiles/.git" --work-tree="$HOME"'
alias venv='python3 -m venv'
alias l='LC_ALL=C EXA_COLORS="da=0;35" exa -lF -a --sort name --git --header'
alias ssh='TERM=xterm ssh'

export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/chromium

git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM"
  local BEHIND="%{$fg[cyan]%}⇣NUM"
  local MERGING="%{$fg[magenta]%}🗲"
  local UNTRACKED="\x1b[38;5;245m●"
  local MODIFIED="\x1b[38;5;196m●"
  local STAGED="\x1b[38;5;107m●"

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
  GIT_INFO+=( "\033[38;5;255m$GIT_LOCATION" )
  GIT_INFO+=( '%{$reset_color%}' )
  echo "\x1b[48;5;89m${(j: :)GIT_INFO}"

}

prompt_setup_umbra(){
  ZSH_THEME_VIRTUALENV_PREFIX=" "
  ZSH_THEME_VIRTUALENV_SUFFIX=" "

  base_prompt='%{$bg[yellow]$fg[black]%}$(virtualenv_prompt_info)%{$reset_color%}%{$bg[cyan]$fg[black]%} %0~ %{$reset_color%}'

  post_prompt=' '
  #post_prompt='%{$fg[cyan]%}⇒%{$reset_color%} '

  #base_prompt_nocolor=$(echo "$base_prompt" | perl -pe "s/%\{[^}]+\}//g")
  #post_prompt_nocolor=$(echo "$post_prompt" | perl -pe "s/%\{[^}]+\}//g")

  precmd_functions+=(prompt_umbra_precmd)
}

prompt_umbra_precmd(){
  local gitinfo=$(git_info)
  #local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  #local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  #local prompt_length=${#exp_nocolor}

  PROMPT="$base_prompt$gitinfo$post_prompt"
}

prompt_setup_umbra

#printf "\x1b[36;1m`date +%H`\x1b[35;1m `date +%M`\x1b[0m"
#printf " `nmcli -t -f active,ssid dev wifi | egrep '^yes' | head -1 | sed "s/yes://g"`\n"
#printf "\n"
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

