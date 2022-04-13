.PHONY: install update sync init

# Add params like --ignore-unknown here
ZYPPER := zypper

init:
ifneq "$(shell command -v zypper || echo none)" "none"
	test $$(id -u) = 0 # Ensure we're running as root
	$(ZYPPER) modifyrepo --all --no-refresh --gpgcheck-strict
	$(ZYPPER) refresh
endif

install: init
ifneq "$(shell command -v zypper || echo none)" "none"
	# Update all deps to latest before installing new ones
	$(ZYPPER) dup
	# Remove all removed.lock packages, and add locks:
	-cat removed.lock | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) remove --name
	cat removed.lock | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) addlock
	# Install packages:
	cat *.txt | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) install
	-$(ZYPPER) ps -s # list packages that need restarting
endif

update: init
ifneq "$(shell command -v zypper || echo none)" "none"
	$(ZYPPER) dup --allow-vendor-change
	-$(ZYPPER) ps -s
endif

sync: ;
