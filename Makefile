SUBDIRS := $(subst /,,$(dir $(wildcard */)))
INSTALL_TARGETS := $(patsubst %,install-%,$(SUBDIRS))
UPDATE_TARGETS := $(patsubst %,update-%,$(SUBDIRS))

.PHONY: install update root-install user-install root-update user-update
.PHONY: $(INSTALL_TARGETS) $(UPDATE_TARGETS)

install: root-install user-install
	@echo "Successfully installed"

update: root-update
	@echo 'Successfully updated'

root-install:
	@echo "Elevating to root to install root settings:"
	su --command="$(MAKE) install-fsroot"
	@echo "Installed root settings"

user-install:
	@echo "Installed user settings"

root-update:
	@echo "Updated root-readable settings"

user-update: update-fsroot
	@echo "Updated user-readable settings"

$(INSTALL_TARGETS):
	make -C $(subst install-,,$@)

$(UPDATE_TARGETS):
	make -C $(subst update-,,$@)

echo:
	echo $(INSTALL_TARGETS)

