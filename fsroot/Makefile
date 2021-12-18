.PHONY: install update

install:
	@echo "Installing system files (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	find . -type d | sed 's:^\.::'    | xargs echo mkdir -p
	find . -type f | grep -v Makefile | xargs -I% echo cp -p % /%

update:
	@echo "Updating system files in this repo (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	find . -type d | sed 's:^\.::'    | xargs mkdir -p
	find . -type f | grep -v Makefile | xargs -I% cp -p /% %
