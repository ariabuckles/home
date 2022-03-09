#!/bin/zsh
sudo() {
  su --login --pty --command="cd '$PWD' && $*"
}

