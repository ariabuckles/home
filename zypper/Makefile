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
	$(ZYPPER) dup # Update all deps to latest before installing new ones
	cat *.txt | grep -v '^\#\|^$$' | xargs -t $(ZYPPER) install
	-$(ZYPPER) ps -s
endif

update: init
ifneq "$(shell command -v zypper || echo none)" "none"
	$(ZYPPER) dup --allow-vendor-change
	-$(ZYPPER) ps -s
endif

sync: ;
