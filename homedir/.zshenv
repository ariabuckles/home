# System Variables
#Macports path:
export ARIAHOME=$HOME
export ZDOTDIR=$ARIAHOME
OS=$(uname -s)
ARCH=$(uname -m)

# Source any zprofile here; then ignore GLOBAL_RCS, since we
# want more control over our path
if [[ -o login ]] && [[ -e /etc/zprofile ]]; then
    source /etc/zprofile
fi
unsetopt GLOBAL_RCS

# Set systemy options:
ulimit -n 16384 || true # increase the max # of files if possible
# Set up zsh compinit paths safely (ignore homebrew):
fpath=($(echo $fpath | sed 's|^/usr/local/[^ ]*||'))

export PYENV_ROOT="$ARIAHOME/.pyenv"
export PYENV_SHELL=$SHELL

# Set up $PATH safely:
# Remove brew's /usr/local/bin from the start of the path (we'll add it to the end)
#export PATH=$(echo $PATH | sed 's|/usr/local/bin:||g')
# System path:
export PATH="/usr/local/bin:/usr/bin:/bin:/opt/bin"
# Homebrew (arm):
if [[ "${OS} ${ARCH}" == "Darwin arm64" ]]; then
  export PATH="$PATH:/opt/homebrew/bin"
fi
# Custom user-installed executables:
export PATH="$PATH:$ARIAHOME/.local/bin"
# Python with pyenv (bin is the pyenv executable when installed from source.
# shims are the bins for python and installed python deps)
#export PATH="$PYENV_ROOT/shims:$PATH"
# And last in the list, node modules bins & python .ve virtualenv bins:
export PATH="$PATH:./node_modules/.bin"
# Auto-be in a virtualenv if the virtualenv is named `.ve`:
#export PATH="$PATH:./.ve/bin"
#export VIRTUAL_ENV="./.ve"

# Android setup & paths:
#export ANDROID_HOME="$ARIAHOME/Library/Android/sdk"
#export ANDROID_SDK="$ANDROID_HOME"
#export PATH="$PATH:$ANDROID_HOME/emulator"
#export PATH="$PATH:$ANDROID_HOME/tools"
#export PATH="$PATH:$ANDROID_HOME/tools/bin"
#export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Custom home directory for ariashell
if [[ "$USER" == "ariashell" && -d "$ARIAHOME/shell" ]]; then
  export HOME="$ARIAHOME/shell"
fi

# Vim / commandline setup:
bindkey -e
# 10ms key sequence timeout:
export KEYTIMEOUT=1

# Node
export NODE_REPL_HISTORY="$HOME/.local/share/node/repl_history"
export MOCHA_REPORTER='spec'

# Telemetry disables:
export NEXT_TELEMETRY_DISABLED=1

# alias -r watchman="/usr/local/Cellar/watchman/4.7.0_1/libexec/bin/watchman --foreground --logfile=/usr/local/var/run/watchman/ariashell-state/log --log-level=1 --sockname=/usr/local/var/run/watchman/ariashell-state/sock --statefile=/usr/local/var/run/watchman/ariashell-state/state --pidfile=/usr/local/var/run/watchman/ariashell-state/pid"

if [ -e ~/.env_vars ]; then
  source ~/.env_vars
fi


if [ -e ~/.secrets.env ]; then
  source ~/.secrets.env
fi

function share {
  chmod -R g=u "$@"
}

function link-docker-sock {
  su aria -c ' \
    chmod g=u "$ARIAHOME/Library" && \
    chmod g=u "$ARIAHOME/Library/Containers" && \
    chmod g=u "$ARIAHOME/Library/Containers/com.docker.docker" && \
    chmod g=u "$ARIAHOME/Library/Containers/com.docker.docker/Data" && \
    chmod g=u "$ARIAHOME/Library/Containers/com.docker.docker/Data/docker.sock" \
  '
}
