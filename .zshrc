# detect OS
OS=`uname -s`

# zsh magic
if [ $OS = 'Darwin' ]; then
	autoload -U compinit
	compinit
fi

# command prompt
export PROMPT='%2~> '

# vim style history with shift-up/down\pageup/down
bindkey "\033[5~" history-beginning-search-backward
bindkey "\033[6~" history-beginning-search-forward

# case insensitive tabbing
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

if [ $OS = 'Linux' ]; then
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
alias -r make='make --warn-undefined-variables'
alias -r valgrindall='valgrind --trace-children=yes'
alias -r valgrindallq='valgrind --trace-children=yes --quiet'
svnlog() { svn log $@ --verbose | less; }
xarg() { while read arg ; do ; $@ "$arg" ; done }
gs() { ls | grep -i -e $@ | xargs ls -G; }

# Set up command line mode (currently vim mode...)

# Add -- COMMAND -- message when in command mode
# http://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/}"            
	RPS2=$RPS1
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# fix backspace key
bindkey '^?' backward-delete-char

# And key bindings
# https://bbs.archlinux.org/viewtopic.php?pid=428669
