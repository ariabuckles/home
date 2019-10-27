#!/bin/zsh
vif() {
  if [[ -n "$1" ]]; then
    file=$(fzf -1 -q "$1")
    [[ -n "$file" ]] && nvim -- "$file"
  else
    file=$(fzf)
    [[ -n "$file" ]] && nvim -- "$file"
  fi
}
vifa() {
  nvim -p -- $(fzf -f "$1")
}
