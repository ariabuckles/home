#!/bin/zsh
# Consistify permissions for files
if [[ "$USER" == "root" ]]; then
  chown -PR aria ~aria/home
  chown -PR aria ~aria/bin
  chown -PR aria ~aria/Documents
  chown aria ~aria/shell
  find -P ~aria/shell -type l -print0 | xargs -0 chown -h aria
  find -P ~aria/shell -type d -print0 | xargs -0 chown -PRh ariashell
fi
if [[ "$USER" != "ariashell" ]]; then
  chmod -R u=rwX,g=rX,o= ~aria/home
  chmod -R u=rwX,g=rX,o= ~aria/bin
  chmod 700 ~aria/Documents
  chmod 750 ~aria/shell
fi
find -P ~aria/shell -type l -print0 | xargs -0 chmod -h 640
find -P ~aria/shell -type d -print0 | xargs -0 chmod -R ug+rX
