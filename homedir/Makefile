.PHONY: install update sync

install:
	# Installing home directory files
	# Linking directories in homedir:
	find . -maxdepth 1 -type d -path './*' | sed 's:^./::' | xargs -tI% rm -rf $${HOME?}/%
	find . -maxdepth 1 -type d -path './*' | sed 's:^./::' | xargs -tI% ln -sfn $(CURDIR)/% $${HOME?}/%
	# Copying files & links in homedir:
	find . -maxdepth 1 -type f,l | sed 's:^./::' | grep -v Makefile | xargs -tI% rm -rf $${HOME?}/%
	find . -maxdepth 1 -type f,l | sed 's:^./::' | grep -v Makefile | xargs -tI% cp -Pp $(CURDIR)/% $${HOME?}/%

update: ;

sync:
	# Copy back just the root files (folders are still symlinks, for now)
	find . -maxdepth 1 -type f,l | sed 's:^./::' | grep -v Makefile | xargs -tI% cp -Pp $${HOME?}/% $(CURDIR)/%
