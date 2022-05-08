.PHONY: install update sync

ifneq "$(shell command -v flatpak)" ""

install:
	test $$(id -u) = 0 # Ensure we're running as root
	for file in *.txt; do \
		repo=$$(echo $$file | sed s'/\.txt//'); \
		flatpak remote-add --if-not-exists $$repo $$(cat $$file | grep '^#repo=' | sed 's/#repo=//'); \
		cat $$file | grep -v '^#\|^$$' | xargs -t flatpak install -y --system $$repo; \
	done

update:
	test $$(id -u) = 0 # Ensure we're running as root
	flatpak update -y

endif

*: ;
