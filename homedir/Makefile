.PHONY: install update sync

install:
	@echo "Installing home directory files"
	find . -type d | sed 's:^\./::'    | xargs -tI% mkdir -p $${HOME}/%
	find . -type f | grep -v Makefile | xargs -tI% cp -p % $${HOME}/%

update: ;

sync:
	# TODO
	;
