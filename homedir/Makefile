.PHONY: install update sync

install:
	# Installing home directory files
	# Linking directories in homedir:
	find . -maxdepth 1 -type d -path './*' | sed 's:^./::' | xargs -tI% ln -sfn $(CURDIR)/% $${HOME}/%
	# Copying files & links in homedir:
	find . -maxdepth 1 -type f,l | sed 's:^./::' | xargs -tI% cp -Pp $(CURDIR)/% $${HOME}/%

update: ;

sync:
	# TODO
	;
