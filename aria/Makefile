.PHONY: install update sync init
ifndef OSNAME
	OSNAME := $(shell ( . /etc/os-release 2>/dev/null && echo $$ID ) || uname -s)
endif

ifeq "$(OSNAME)" "Darwin"

install: ;

update: ;

sync: ;

else

install:
	test -x /bin/zsh && usermod -s /bin/zsh aria

update: install ;

sync: ;

endif
