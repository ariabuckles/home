#!/bin/zsh
vif() {
  if [[ "$#" -gt 0 ]]; then
    file=$(fzf --preview='bat --style=full --color=always {}' -1 -q "$*")
    [[ -n "$file" ]] && nvim -- "$file"
  else
    file=$(fzf --preview='bat --style=full --color=always {}')
    [[ -n "$file" ]] && nvim -- "$file"
  fi
}
vifa() {
  nvim -p -- $(fzf -f "$*")
}
