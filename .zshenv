# System Variables
#Macports path:
export ZDOTDIR=$HOME

# Source any zprofile here; then ignore GLOBAL_RCS, since we
# want more control over our path
if [[ -o login ]] && [[ -e /etc/zprofile ]]; then
    source /etc/zprofile
fi
unsetopt GLOBAL_RCS


# Set up $PATH safely:
# Remove brew's /usr/local/bin from the start of the path (we'll add it to the end)
export PATH=$(echo $PATH | sed 's|/usr/local/bin:||g')
# Custom executables:
export PATH="$PATH:$HOME/bin"
# Homebrew:
export PATH="$PATH:/usr/local/bin"
# Macports:
export PATH="$PATH:/opt/local/bin"
export MANPATH="$MANPATH:/opt/local/share/man"
# Python bins:
export PATH="$PATH:$HOME/Library/Python/2.7/bin"
# And last in the list, node modules bins:
export PATH="$PATH:./node_modules/.bin"

# Android setup & paths:
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"


# Vim / commandline setup:
export EDITOR=vim
bindkey -e

# Custom Variables
export POLARIS='toole1@ews-polaris04.cs.illinois.edu'
export MONAD='https://ariabuckles@bitbucket.org/ariabuckles/monad'

alias -r watchman="/usr/local/Cellar/watchman/4.7.0_1/libexec/bin/watchman --foreground --logfile=/usr/local/var/run/watchman/ariashell-state/log --log-level=1 --sockname=/usr/local/var/run/watchman/ariashell-state/sock --statefile=/usr/local/var/run/watchman/ariashell-state/state --pidfile=/usr/local/var/run/watchman/ariashell-state/pid"

if [ -e ~/.env_vars ]; then
  source ~/.env_vars
fi

if [ -e ~/.secrets.env ]; then
  source ~/.secrets.env
fi

if [ -e ~/.virtualenv/khan27/bin/activate ]; then
  source ~/.virtualenv/khan27/bin/activate
fi

export MOCHA_REPORTER='spec'

function share {
  chmod -R g=u "$@"
}
