.PHONY: install update sync

ifeq "$(shell uname -s)" "Darwin"

install:
	@echo "Installing brew libraries (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	# Copy over homebrew files to homebrew user:
	find . -type f,l | grep -v Makefile | xargs -t -I% cp % ~homebrew/%
	# fix permissions of files copied by sudo:
	find . -type f | grep -v Makefile | xargs -t -I% chown homebrew ~homebrew/%
	# Install Brewfile:
	sudo -u homebrew -i brew bundle install --file Brewfile
	-sudo xattr -d com.apple.quarantine /Applications/* 2>/dev/null

update:
	test $$(id -u) = 0 # Ensure we're running as root
	-sudo -u homebrew -i brew update
	-sudo -u homebrew -i brew upgrade --greedy
	-sudo xattr -d com.apple.quarantine /Applications/* 2>/dev/null

sync: ;

endif

*: ;
