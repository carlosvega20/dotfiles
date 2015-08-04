
#Preferences

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^R" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


#Exports

export EDITOR=vim

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export TERM=xterm-256color        # for common 256 color terminals (e.g. gnome-terminal)
export TERM=screen-256color       # for a tmux -2 session (also for screen)

#Utilities

alias ls="ls -Gh"

alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

#Open Vim with nerdTree
alias vimt='vim +NERDTree'

#Install vim Vundle plugins 
alias vimv='vim +PluginInstall +qall'
#History
alias h='history'

function hs
{
    history | grep $*
}

alias hsi='hs -i'


#Theme

autoload -U colors && colors

LOCAL_STATUS="%(?:%{$fg_bold[white]%}:%{$fg_bold[red]%}● %s)"

GIT_PROMPT_PREFIX="[ %{$fg_bold[green]%}%{$reset_color%}%{$fg_bold[red]%}"
GIT_PROMPT_SUFFIX="%{$reset_color%} ]"
GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

git_status () {
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _STATUS=""
  if $(echo "$_INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_STAGED"
  fi
  if $(echo "$_INDEX" | grep '^.[MTD] ' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$_INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$_INDEX" | grep '^UU ' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_UNMERGED"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    _STATUS="$_STATUS$GIT_PROMPT_STASHED"
  fi
  if $(echo "$_INDEX" | grep '^## .*ahead' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | grep '^## .*behind' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | grep '^## .*diverged' &> /dev/null); then
    _STATUS="$_STATUS$GIT_PROMPT_DIVERGED"
  fi

  echo $_STATUS
}

git_prompt () {
  local _branch=$(git_branch)
  local _status=$(git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="git: $GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_status $_result"
    fi
    _result="$_result$GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


setopt prompt_subst
PROMPT="${LOCAL_STATUS} %{$fg[cyan]%}%c %{$reset_color%}"
RPROMPT='$(git_prompt)'

#boot2docker exports
export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376

function java_use() {
    export JAVA_HOME=$(/usr/libexec/java_home -v $1)
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}

java_use 1.7
