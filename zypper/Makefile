.PHONY: install update sync init

ifneq "$(shell command -v transactional-update)", ""
	ZYPPER_INSTALL := transactional-update pkg install
	ZYPPER_UPDATE := transactional-update dup
else ifneq "$(shell command -v zypper)", ""
	# Add params like --ignore-unknown here:
	ZYPPER_INSTALL := zypper install
	ZYPPER_UPDATE := zypper dup --allow-vendor-change
else
	ZYPPER_INSTALL :=
	ZYPPER_UPDATE :=
endif

init:
ifneq "$(ZYPPER_INSTALL)" ""
	test $$(id -u) = 0 # Ensure we're running as root
	zypper modifyrepo --all --no-refresh --gpgcheck-strict
	zypper refresh
endif

install: init
ifneq "$(ZYPPER_INSTALL)" ""
	# Update all deps to latest before installing new ones
	$(ZYPPER_UPDATE)
	# Remove all removed.lock packages, and add locks:
	-cat removed.lock | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) remove --name
	cat removed.lock | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) addlock
	# Install packages:
	cat *.txt | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) install
	-$(ZYPPER) ps -s # list packages that need restarting
endif

update: init
ifneq "$(ZYPPER_UPDATE)" ""
	$(ZYPPER_UPDATE)
	-zypper ps -s
endif

sync: ;
