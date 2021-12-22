#!/bin/zsh
# Open file(s) with content matching regex:
vig() { nvim -p +1 -c '/\v'"$*" -- $(rg -S --hidden -l "$*") }
