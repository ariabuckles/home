# detect OS
OS=`uname -s`

# zsh magic completion
# disabled cause insecure warning right now
#autoload -zU compinit
#compinit

# command prompt
# export PROMPT='%2~> '
if [[ "$USER" = "aria" && -o login ]] && `id ariashell &>/dev/null`; then
  exec sudo -u ariashell -s
elif [[ "$USER" = "aria" ]] && `id ariashell &>/dev/null`; then
  export PROMPT='%2{❗️%} %2~> '
elif [[ "$USER" = "aria" ]]; then
  export PROMPT='%2{❤️ %} %2~> '
elif [[ "$USER" = "ariashell" ]]; then
  alias brew="sudo -u homebrew -i"
  export PROMPT='%2{💖%} %2~> '
else
  export PROMPT='%2{‼️ %} ERR:%n>'
fi

# Zsh options
# roughly alias cd=pushd:
setopt autopushd
alias pd=popd

# vim style history with shift-up/down\pageup/down
bindkey "\033[5~" history-beginning-search-backward
bindkey "\033[6~" history-beginning-search-forward

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
HISTSIZE=1000
SAVEHIST=1000
if [[ "$USER" = "ariashell" ]]; then
  HISTFILE=/Users/ariashell/.zsh_history
else
  HISTFILE=~/.zsh_history
  chmod 600 "$HISTFILE"
fi

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
alias -r src='source ~/.zshenv && source ~/.zshrc'
svnlog() { svn log $@ --verbose | less; }
xarg() { while read arg ; do ; $@ "$arg" ; done }
alias -r l="ls $ls_color"
alias -r c="cd"
alias -r m="make --warn-undefined-variables"
alias -r v="vim"
lg() { ls | grep -i -e $@ | xargs ls -G; }
alias -r viewer='view -'
alias -r vim='vim -p'
# Open file(s) with name matching regex:
vif() { vim -- $(fd $@) }
# Open file(s) with content matching regex:
vig() { vim -c "/$1" -- $(rg -l $@) }

# git aliases
alias -r g='git'
gd() { git diff $@ | vim -R - }
gf() { git fetch && git stash && git rebase $@ && git stash pop }
gl() { git log $@ | less }
glv() { git log --name-status $@ | less }
alias -r gci='git commit'
alias -r gco='git checkout'
alias -r ga='git add'
alias -r gs='git status'
alias -r gb='git branch'
alias -r ag='rg -S'
alias -r rg='rg -S'
alias -r wget='curl -O'

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
if which rbenv &>/dev/null; then
  eval "$(rbenv init - zsh)"
fi

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
alias yarn="identify && yarn"

export APACHE_CONFIG="/private/etc/apache2/httpd.conf"
export APACHE_VHOSTS="/private/etc/apache2/extra/httpd-vhosts.conf"

function path {
  echo $PATH | tr ':' '\n'
}

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

# Seesaw
alias mc="cd ~/depot/mcam/MagicCameraServer/mcserver"
alias superctl="supervisorctl -s http://localhost:9001"

# Current work:
export webapp="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp"
export drawing_tool="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp/app/js/app/react/creative_tools/drawing_tool"
export seesaw_library="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp/app/js/shared/react/library"

# re-enable global rcs after we're done...
setopt GLOBAL_RCS
