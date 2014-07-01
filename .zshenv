# System Variables
#Macports path:
export PATH=$PATH:/usr/local/bin:/opt/local/bin:/opt/local/sbin
export MANPATH=$MANPATH:/opt/local/share/man
export PATH="$HOME/khan/devtools/arcanist/khan-bin:$PATH"
export PATH=./node_modules/.bin:$HOME/bin:$HOME/opt/bin:$PATH
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
  echo "sourced virtualenv"
fi

export MOCHA_REPORTER='spec'
echo "zshenv loaded"
