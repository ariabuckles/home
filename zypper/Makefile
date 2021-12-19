.PHONY: install update sync

# Add params like --ignore-unknown here
ZYPPER := zypper

install:
	test $$(id -u) = 0 # Ensure we're running as root
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install

update:
	test $$(id -u) = 0 # Ensure we're running as root
	$(ZYPPER) refresh
	$(ZYPPER) dup --allow-vendor-change
	$(ZYPPER) ps -s

sync: ;
