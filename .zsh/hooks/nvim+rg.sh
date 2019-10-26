#!/bin/zsh
# Open file(s) with content matching regex:
vig() { vim -c "/$1" -- $(rg -l $@) }
