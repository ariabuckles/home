#!/bin/zsh
alias -r vim="nvim -p"
alias -r view="nvim -c 'setlocal nomodified | setlocal nomodifiable'"
alias -r viewer="nvim - -c 'setlocal nomodified | setlocal nomodifiable'"
export EDITOR=nvim
export VISUAL=nvim
