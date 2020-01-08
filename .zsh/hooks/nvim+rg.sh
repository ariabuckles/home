#!/bin/zsh
# Open file(s) with content matching regex:
vig() { nvim -p -c '/\v'"$*" -- $(rg -S --hidden -l "$*") }
