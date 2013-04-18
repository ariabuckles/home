if status --is-login
	# Macports Path
	set -x PATH $PATH /usr/local/bin /opt/local/bin /opt/local/sbin
	
    # custom bins
	set -x PATH $PATH $HOME/bin
	
    # npm path
    set -x PATH $PATH $HOME/node_modules/.bin

	# luarocks path
	set -x PATH $PATH /opt/local/share/luarocks/bin

	set -x EDITOR vim

	set -x JAVA_HOME '/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home'

	set -x MOCHA_REPORTER 'spec'
end
