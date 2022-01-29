.PHONY: install update sync ensure-is-root

# Add params like --ignore-unknown here
ZYPPER := zypper

ensure-is-root:
	test $$(id -u) = 0 # Ensure we're running as root

install: ensure-is-root
	$(ZYPPER) modifyrepo --all --no-refresh --gpgcheck-strict
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install

update: ensure-is-root
	$(ZYPPER) refresh
	$(ZYPPER) dup --allow-vendor-change
	-$(ZYPPER) ps -s

sync: ;
