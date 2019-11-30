#!/bin/zsh
# Open file(s) with content matching regex:
vig() { vim -c '/\v'"$1" -- $(rg -l $@) }
