.PHONY: install update

# Add params like --ignore-unknown here
ZYPPER := zypper

install:
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install

update: ;
