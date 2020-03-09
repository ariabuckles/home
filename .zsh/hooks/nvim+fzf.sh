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
  if [[ "$#" -gt 0 ]]; then
    nvim -p -- $(fzf -f "$*")
  else
    nvim -p -- $(git diff --relative --name-only master...HEAD)
  fi
}
vifd() {
  if [[ "$#" -gt 0 ]]; then
    file=$(git diff --relative --name-only master...HEAD | fzf --preview='bat --style=full --color=always {}' -1 -q "$*")
    [[ -n "$file" ]] && nvim -- "$file"
  else
    file=$(git diff --relative --name-only master...HEAD | fzf --preview='bat --style=full --color=always {}')
    [[ -n "$file" ]] && nvim -- "$file"
  fi
}
