# System Variables
#Macports path:
export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export PATH="$HOME/khan/devtools/arcanist/khan-bin:$PATH"
export PATH="$HOME/khan/devtools/git-bigfile/bin:$PATH"
export PATH=$HOME/bin:$HOME/opt/bin:$PATH:./node_modules/.bin
export EDITOR=vim 
bindkey -e
export NACL_SDK_ROOT="$HOME/Code/nacl_sdk/pepper_18"

# Custom Variables
export POLARIS='toole1@ews-polaris04.cs.illinois.edu'
export MONAD='https://jacktoole1@bitbucket.org/jacktoole1/monad'

if [ -e ~/.env_vars ]; then
	source ~/.env_vars
fi

if [ -e ~/.virtualenv/khan27/bin/activate ]; then
  source ~/.virtualenv/khan27/bin/activate
fi

export MOCHA_REPORTER='spec'
