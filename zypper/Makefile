.PHONY: install update sync init

ifneq "$(shell command -v transactional-update)", ""

init:
	test $$(id -u) = 0 # Ensure we're running as root
	zypper modifyrepo --all --no-refresh --gpgcheck-strict
	zypper refresh

install: init
	# Install packages:
	cat *.txt | grep -v '^\#\|^$$' | xargs -t transactional-update pkg install

update: init
	transactional-update dup

sync: ;

else ifneq "$(shell command -v zypper)", ""

init:
	test $$(id -u) = 0 # Ensure we're running as root
	zypper modifyrepo --all --no-refresh --gpgcheck-strict
	zypper refresh

install: init
	# Update all deps to latest before installing new ones
	zypper dup
	# Remove all removed.lock packages, and add locks:
	-cat removed.lock | grep -v '^\#\|^$$' | xargs -t zypper remove --name
	cat removed.lock | grep -v '^\#\|^$$' | xargs -t zypper addlock
	# Install packages:
	cat *.txt | grep -v '^\#\|^$$' | xargs -t zypper install
	-zypper ps -s # list packages that need restarting

update: init
	zypper dup --allow-vendor-change
	-zypper ps -s

sync: ;

else

init: ;

install: ;

update: ;

sync: ;

endif
