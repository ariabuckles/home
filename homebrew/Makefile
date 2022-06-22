.PHONY: install update sync

ifeq "$(shell uname -s)" "Darwin"

install:
	@echo "Installing brew libraries (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	# Copy over homebrew files to homebrew user:
	find . -type f,l | grep -v Makefile | xargs -t -I% cp % ~homebrew/%
	chown -R homebrew ~homebrew # fix permissions of files copied by sudo
	# Install Brewfile:
	sudo -u homebrew -i brew bundle install

update:
	test $$(id -u) = 0 # Ensure we're running as root
	sudo -u homebrew -i brew update
	sudo -u homebrew -i brew upgrade

sync: ;

endif

*: ;
