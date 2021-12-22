#!/bin/zsh
vif() {
  if [[ "$#" -gt 0 ]]; then
    files=$(fzf --multi --preview='bat --style=full --color=always {}' -1 -q "$*" --print0)
    [[ -n "$files" ]] && echo -n $files | xargs -0 nvim -p --
  else
    files=$(fzf --multi --preview='bat --style=full --color=always {}' --print0)
    [[ -n "$files" ]] && echo -n $files | xargs -0 nvim -p --
  fi
}
vifa() {
  if [[ "$#" -gt 0 ]]; then
    nvim -p -- $(fzf -f "$*")
  else
    nvim -p -- $(git diff --relative --name-only $(git get-main)...HEAD)
  fi
}
vifd() {
  if [[ "$#" -gt 0 ]]; then
    files=$(git diff --relative --name-only master...HEAD | fzf --multi --preview='bat --style=full --color=always {}' -1 -q "$*" --print0)
    [[ -n "$files" ]] && echo -n $files | xargs -0 nvim -p --
  else
    files=$(git diff --relative --name-only master...HEAD | fzf --multi --preview='bat --style=full --color=always {}' --print0)
    [[ -n "$files" ]] && echo -n $files | xargs -0 nvim -p --
  fi
}
