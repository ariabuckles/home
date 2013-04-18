# System Variables
#Macports path:
export PATH=$PATH:/usr/local/bin:/opt/local/bin:/opt/local/sbin
export MANPATH=$MANPATH:/opt/local/share/man
# luarocks path:
export PATH=$PATH:/opt/local/share/luarocks/bin
export SCALA_HOME=$HOME/scala
export PATH=$HOME/bin:$SCALA_HOME/bin:$PATH
export EDITOR=vim 
bindkey -e
export NACL_SDK_ROOT="$HOME/Code/nacl_sdk/pepper_18"

# coffeescript:
export PATH=$HOME/node_modules/coffee-script/bin:$PATH
export PATH=$HOME/node_modules/mocha/bin:$PATH

# Vertx
export PATH="$PATH:$HOME/Code/vertx/vert.x-1.3.1.final/bin"

# Java
export JAVA_HOME='/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home'

# Custom Variables
export SVN='https://subversion.ews.illinois.edu/svn/su12-cs225/'
export STAFF='https://subversion.cs.illinois.edu/svn/cs225/'
export EWS='toole1@linux6.ews.illinois.edu'
export POLARIS='toole1@ews-polaris04.cs.illinois.edu'
export MONAD='https://jacktoole1@bitbucket.org/jacktoole1/monad'
export ICDM='icdm@dmserv2.cs.illinois.edu'

if [ -e ~/.env_vars ]; then
	source ~/.env_vars
fi

export MOCHA_REPORTER='spec'
