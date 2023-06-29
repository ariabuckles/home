.PHONY: install update sync

install:
	test $$(id -u) = 0 # Ensure we're running as root
	sudo -u "$$SUDO_USER" defaults write com.apple.finder CreateDesktop 0 # hide desktop icons
	-sudo -u "$$SUDO_USER" killall Finder # restart desktop

update:
	test $$(id -u) = 0 # Ensure we're running as root

sync: ;
