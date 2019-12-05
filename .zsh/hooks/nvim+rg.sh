#!/bin/zsh
# Open file(s) with content matching regex:
vig() { nvim -c '/\v'"$1" -- $(rg -l $@) }
