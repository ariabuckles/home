# System Variables
#Macports path:
export PATH=$PATH:/usr/local/bin:/opt/local/bin:/opt/local/sbin
export MANPATH=$MANPATH:/opt/local/share/man
export PATH="$HOME/khan/devtools/arcanist/khan-bin:$PATH"
export PATH=$HOME/bin:$HOME/opt/bin:$PATH
export EDITOR=vim 
bindkey -e
export NACL_SDK_ROOT="$HOME/Code/nacl_sdk/pepper_18"

# coffeescript:
export PATH=$HOME/node_modules/coffee-script/bin:$PATH
export PATH=$HOME/node_modules/mocha/bin:$PATH

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
