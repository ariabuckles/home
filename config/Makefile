.PHONY: install update sync

install:
	@echo "Installing config directory"
	mkdir -p $${HOME}/.config
	find . -maxdepth 1 -type d -path './*' | sed 's:^./::' | xargs -tI% rm -rf $${HOME}/.config/%
	find . -maxdepth 1 -type d -path './*' | sed 's:^./::' | xargs -tI% ln -sfn $(CURDIR)/% $${HOME}/.config/%

update: ;

sync: ;
