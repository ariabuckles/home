.PHONY: install update

ZYPPER := zypper --non-interactive --non-interactive-include-reboot-patches --ignore-unknown

install:
	zypper refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t zypper install

update: ;
