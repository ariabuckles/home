# detect OS
OS=`uname -s`

# zsh magic completion
# Re-enabled after fixing fpath in .zshenv:
autoload -zU compinit
compinit

# command prompt
export PROMPT='%2~> '
setopt promptpercent
if [[ "$USER" = "aria" && -o login ]] && id ariashell &>/dev/null; then
  exec sudo -u ariashell -s
elif [[ "$USER" = "aria" ]] && id ariashell &>/dev/null; then
  export PROMPT='%2{❗️%} %2~> '
elif [[ "$USER" = "aria" ]]; then
  export PROMPT='%2{%(0?.❤️ .💔)%} %2~> '
elif [[ "$USER" = "ariashell" ]]; then
  export PROMPT='%2{%(0?.💖.🧡)%} %2~> '
else
  export PROMPT='%2{‼️ %} ERR:%n>'
fi

if id homebrew &>/dev/null; then
  brew() {
    sudo -u homebrew -i zsh -c "cd '$(pwd)'; brew $*"
  }
fi

function ado {
  if [[ "$*" = "" ]]; then
    su aria
  else
    su aria -c "$*"
  fi
}
function revan {
  if [[ "$*" = "" ]]; then
    su revan -c "zsh"
  else
    su revan -c "$*"
  fi
}

# Zsh options
# roughly alias cd=pushd:
setopt autopushd
alias pd=popd

# Disable Ctrl-S stopping visible output:
setopt noflowcontrol

if [[ "$KBD_LAYOUT" = "colemak" && "$GNOME_TERMINAL_SERVICE" != "" ]]; then
  stty intr ^K
  bindkey '^U' quoted-insert
fi

# vim style history with up/down
# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^U' backward-word
bindkey '^O' forward-word
# old sort-of vim style history with shift-up/down\pageup/down
#bindkey "\033[5~" history-beginning-search-backward
#bindkey "\033[6~" history-beginning-search-forward

# case insensitive tabbing
# OLD zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete # _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.local/zsh_history"
touch "$HISTFILE"
chmod 600 "$HISTFILE"

# hack to make mac git complete fast
__git_files () { 
	_wanted files expl 'local files' _files
}

# OS-Specific things (ls colors etc)
if [ $OS = 'Linux' ]; then
  eval "$(dircolors -b)"
	ls_color='--color=auto'
fi

if [ $OS = 'Darwin' ]; then
	ls_color='-G'
	alias -r valgrind='valgrind --dsymutil=yes'
	alias -r tailf='tail -f'

	# Set Apple Terminal.app resume directory
	# http://superuser.com/questions/313650/resume-zsh-terminal-os-x-lion
	if [[ $TERM_PROGRAM == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]
	{
		function chpwd
		{
			local SEARCH=' '
			local REPLACE='%20'
			local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
			printf '\e]7;%s\a' "$PWD_URL"
		}
		chpwd
	}
	alias chrome='open /Applications/Google\ Chrome.app'
	alias preview='open /Applications/Preview.app'
	alias safe='xattr -rd com.apple.quarantine'
	alias xcode_enableindexing='defaults write com.apple.dt.XCode IDEIndexDisable 0'
	alias xcode_disableindexing='defaults write com.apple.dt.XCode IDEIndexDisable 1'
fi

# aliases
alias -r ls="ls $ls_color"
alias -r cim='vim'
alias -r vm='vim'
alias -r make='make --warn-undefined-variables'
alias -r valgrindall='valgrind --trace-children=yes'
alias -r valgrindallq='valgrind --trace-children=yes --quiet'
alias -r src='source ~/.zshenv && source ~/.zshrc && rehash'
svnlog() { svn log $@ --verbose | less; }
xarg() { while read arg ; do ; $@ "$arg" ; done }
alias -r l="ls $ls_color"
alias -r c="cd"
alias -r m="make --warn-undefined-variables"
alias -r vi="vim"
lg() { ls | grep -i -e $@ | xargs ls -G; }
alias -r serve='python3 -m http.server'

# vim modes
alias -r viewer='view -'
alias -r vim='vim -p'
# Open file(s) with name matching regex:
vif() { vim -p -- $(find . -type f | grep $@) }
vifa() { vim -p -- $(find . -type f | grep $@) }
# Open file(s) with content matching regex:
vig() { vim +1 -c '\\v'"$*" -- $(git grep -l "$*") }
# Alias vim-style space+o to vif
alias o=vif

# hacky cat?

function cat {
  for file in "$@"; do
    echo "$var"
    if [[ -d "$file" ]]; then
      ls "$ls_color" "$file"
    else
      bat -pp "$file"
    fi
  done
}

# Set up command line mode (currently vim mode...)

# Add -- COMMAND -- message when in command mode
# http://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/}"
	RPS2=$RPS1
	zle reset-prompt
}
#zle -N zle-line-init
#zle -N zle-keymap-select

# fix backspace key
bindkey '^?' backward-delete-char

# And key bindings
# https://bbs.archlinux.org/viewtopic.php?pid=428669

# Java settings
alias setjava7='source setjava7.sh'

# Ruby & Rails settings
# rbenv:
# if command -v rbenv >/dev/null; then
#   eval "$(rbenv init - zsh)"
# fi

# pyenv
if [[ -e "$PYENV_ROOT/.git" ]]; then
  pyenv-update() {
    (cd "$PYENV_ROOT" && git pull --rebase)
  }
fi
#if command -v pyenv >/dev/null; then
#  pyenv rehash
#fi

# bundle exec rails fanciness
function r {
    bundle exec rails "$@"
}

function rcap {
    bundle exec cap "$@"
}

function rk {
    bundle exec rake "$@"
}

alias -r rc='rlwrap bundle exec rails console'

function remount {
    sudo kextunload -b com.apple.driver.AppleSDXC
    sudo kextload -b com.apple.driver.AppleSDXC
}

# ssh identity stuff
function identify {
    if [ -z "$SSH_AGENT_PID" ]; then
        eval `ssh-agent -s`
        eval ssh-add
    fi
}

function path {
  echo $PATH | tr ':' '\n'
}

# https://sidneyliebrand.io/blog/how-fzf-and-ripgrep-improved-my-workflow#installing-brew-plugins
# https://github.com/junegunn/fzf
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!/.git/'"
export FZF_DEFAULT_OPTS="--exact --reverse --tiebreak=length,end --color=16"

# better interactive pagers:
export PAGER='less -F'
export MANPAGER='nvim +Man!'
export MANWIDTH=80

# Json tricks (https://news.ycombinator.com/item?id=20245913)
# Writing https://github.com/tomnomnom/gron in jq
function gron {
  # Pass stdin or $1 as the file, if specified:
  if (( $# == 0 )) ; then cat - ; else cat $1 ; fi | jq -r --stream '
    select(length > 1)
    | (
      .[0] | map(
        if tostring | test("^[A-Za-z$_][0-9A-Za-z$_]*$")
        then "." + .
        else "[" + @json + "]"
        end
      ) | add
    )
    + " = "
    + (.[1] | @json)
  '
}
function ungron {
  # Add ' |' to every line, add '.' to the last line,
  # then pass that input as the program to jq, to operate
  # on a default null/empty object
  sed -e 's/$/ |/' -e '$s/$/./' | jq -nf /dev/stdin
}

function hi {
  local hour="$(date +%H)"
  local name
  (id -F 2>/dev/null || id -un 2>/dev/null) | read -r -d ' ' name
  local partOfDay
  local message
  if [[ $hour -lt 6 ]]; then
    partOfDay='night'
    message="Please set yourself up for sleep before you get tired 🌌!"
  elif [[ $hour -lt 12 ]]; then
    partOfDay='morning'
    message="Hope you've got some tea 🍵!"
  elif [[ $hour -lt 18 ]]; then
    partOfDay='afternoon'
    message="Please remember to take a step back and decide what to do next 💖~"
  elif [[ $hour -lt 21 ]]; then
    partOfDay='evening'
    message="What's something you're proud of about today? 🎀"
  else
    partOfDay='night'
    message="Please go to bed 🌌!"
  fi

  echo "Good ${partOfDay}, ${name}. ${message}"
}

# Load our zsh hooks:
if [[ -e ~/.zsh/load-hooks ]]; then
  source ~/.zsh/load-hooks
fi

# Set up git ramdisk workspace:
source ~/.zsh/ramdisk

# viridum + pbcopy
if [[ -e /usr/bin/pbcopy ]]; then
  v() {
    if [[ $# -eq 0 ]]; then
      echo ' ' | tr -d '\n' | /usr/bin/pbcopy
      echo 'cleared'
    else
      echo '' | tr -d '\n' | /usr/bin/pbcopy  # totally clear out the clipboard first
      viridium "$@" | tr -d '\n' | /usr/bin/pbcopy
    fi
  }
else
  v() {
    viridium "$@"
  }
fi

# Helpful functions
alias new-ssh-key="ssh-keygen -t ed25519 -a 100 -C aria@$(hostname)"

# gnome-terminal inherit cwd:
if [[ -n $VTE_VERSION ]] && [[ -e /etc/profile.d/vte.sh ]]; then
  source /etc/profile.d/vte.sh
fi

# openSUSE command-not-found: https://www.unix.com/man-page/suse/1/command-not-found/
# From oh-my-zsh, MIT Licensed
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/command-not-found/command-not-found.plugin.zsh
if [[ -x /usr/bin/command-not-found ]]; then
  command_not_found_handler() {
    /usr/bin/command-not-found "$1"
  }
fi

# Dev setups for terminals
rbinit() {
  export PROMPT='%2{%(0?.💎.🌩 )%} %2~> '
  eval "$(rbenv init - zsh)"
}

# Allow local excensions:
if [[ -e ~/.zsh/local ]]; then
  source ~/.zsh/local
fi

# re-enable global rcs after we're done...
setopt GLOBAL_RCS
