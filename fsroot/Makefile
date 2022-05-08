.PHONY: install update sync

ifneq "$(shell uname -s)" "Linux"

install:
	@echo "Installing system files (must be run under sudo)"
	test $$(id -u) = 0 # Ensure we're running as root
	find . -type d | sed 's:^\.::'    | xargs -t mkdir -p
	find . -type f,l | grep -v Makefile | xargs -t -I% cp -Pp % /%

update: ;

sync:
	@echo "Updating system files in this repo (must be run under sudo)"
	-find . -type f,l | grep -v Makefile | xargs -t -I% cp -Pp /% %

endif

*: ;
