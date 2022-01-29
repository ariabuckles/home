.PHONY: install update sync ensure-is-root

# Add params like --ignore-unknown here
ZYPPER := zypper

ensure-is-root:
	test $$(id -u) = 0 # Ensure we're running as root

install: ensure-is-root
ifneq "$(shell command -v zypper || echo none)" "none"
	$(ZYPPER) modifyrepo --all --no-refresh --gpgcheck-strict
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install
endif

update: ensure-is-root
ifneq "$(shell command -v zypper || echo none)" "none"
	$(ZYPPER) refresh
	$(ZYPPER) dup --allow-vendor-change
	-$(ZYPPER) ps -s
endif

sync: ;
