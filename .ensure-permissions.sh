#!/bin/zsh
# Consistify permissions for files
if [[ "$USER" == "root" ]]; then
  chown -PR aria ~aria/home
  chown -PR aria ~aria/bin
  chown -PR aria ~aria/Documents
  find -P ~aria/shell -type l | xargs chown -h aria
  find -P ~aria/shell -type d | xargs chown -PRh ariashell
fi
if [[ "$USER" != "ariashell" ]]; then
  chmod -R u=rwX,g=rX,o= ~aria/home
  chmod -R u=rwX,g=rX,o= ~aria/bin
  chmod 700 ~aria/Documents
fi
find -P ~aria/shell -type l | xargs chmod -h 640
find -P ~aria/shell -type d | xargs chmod -R ug+rX
