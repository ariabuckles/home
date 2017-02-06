# detect OS
OS=`uname -s`

# zsh magic completion
# disabled cause insecure warning right now
#autoload -zU compinit
#compinit

# command prompt
# export PROMPT='%2~> '
if [[ "$USER" = "ariashell" ]]; then
  export PROMPT='💖 %2~> '
elif [[ "$USER" = "aria" ]]; then
  export PROMPT='❗️ %2~> '
else
  export PROMPT='‼️ ERR>'
fi

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
alias -r cp='cp -i'
alias -r mv='mv -i'
alias -r rm='rm -i'
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
alias -r ag='ag -S'
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

export APACHE_CONFIG="/private/etc/apache2/httpd.conf"
export APACHE_VHOSTS="/private/etc/apache2/extra/httpd-vhosts.conf"
