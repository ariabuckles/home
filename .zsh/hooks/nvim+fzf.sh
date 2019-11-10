#!/bin/zsh
vif() {
  if [[ "$#" -gt 0 ]]; then
    file=$(fzf -1 -q "$*")
    [[ -n "$file" ]] && nvim -- "$file"
  else
    file=$(fzf)
    [[ -n "$file" ]] && nvim -- "$file"
  fi
}
vifa() {
  nvim -p -- $(fzf -f "$*")
}
