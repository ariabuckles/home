# System Variables
#Macports path:
export ZDOTDIR=$HOME
export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export PATH="$HOME/khan/devtools/arcanist/khan-bin:$PATH"
export PATH="$HOME/khan/devtools/git-bigfile/bin:$PATH"
export PATH=$HOME/bin:$HOME/opt/bin:$PATH:./node_modules/.bin
export EDITOR=vim 
bindkey -e
export NACL_SDK_ROOT="$HOME/Code/nacl_sdk/pepper_18"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK=$HOME/android-sdk-macosx
export ANDROID_NDK=$HOME/your_unix_name/android-ndk/android-ndk-r10e

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
