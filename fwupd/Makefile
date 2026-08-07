.PHONY: install update sync init

ifneq "$(shell command -v fwupdmgr)" ""

init:
	test $$(id -u) = 0 # Ensure we're running as root
	-fwupdmgr refresh

install: init
	-fwupdmgr update

update: init
	-fwupdmgr update

sync: ;

else

init: ;

install: ;

update: ;

sync: ;

endif
