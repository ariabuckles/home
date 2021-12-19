.PHONY: install update sync

install:
	@echo "Installing system files (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	find . -type d | sed 's:^\.::'    | xargs -t mkdir -p
	find . -type f | grep -v Makefile | xargs -t -I% cp -p % /%

update: ;

sync:
	@echo "Updating system files in this repo (must be run under sudo)"
	# TODO(aria): Ignore nonexistant files
	find . -type f | grep -v Makefile | xargs -t -I% cp -p /% %
