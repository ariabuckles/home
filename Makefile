# Find subsystems based on subdirectories:
SUBDIRS := $(subst /,,$(dir $(wildcard */)))
INSTALL_TARGETS := $(patsubst %,install-%,$(SUBDIRS))
UPDATE_TARGETS := $(patsubst %,update-%,$(SUBDIRS))
SYNC_TARGETS := $(patsubst %,sync-%,$(SUBDIRS))

# Mark all targets as always needing a rerun:
.PHONY: install update root-install user-install root-update user-update root-sync user-sync
.PHONY: $(INSTALL_TARGETS) $(UPDATE_TARGETS)

# Primary commands: install, update, sync

install: root-install
	$(MAKE) user-install
	@echo "Successfully installed"

update: root-update
	$(MAKE) user-update
	@echo "Successfully updated"

sync: root-sync user-sync
	@echo "Sync complete"

# Subtargets for root vs user separation:
# Install:

root-install:
	@echo "Elevating to root to install root settings:"
	su --command="$(MAKE) install-fsroot install-zypper install-flatpak"
	@echo "Installed root settings"

user-install: install-npm
	@echo "Installed user settings"

# Update:
root-update: update-fsroot update-zypper update-flatpak
	@echo "Updated root software"

user-update: update-npm
	@echo "Updated user software"

# Sync:
root-sync: sync-fsroot sync-zypper sync-flatpak
	@echo "Synced root settings"

user-sync: sync-npm
	@echo "Synced user settings"

# Subtargets for specific directory subsystems:

$(INSTALL_TARGETS):
	make -C $(subst install-,,$@)

$(UPDATE_TARGETS):
	make -C $(subst update-,,$@)

# Targets that have order dependencies:
install-zypper: install-fsroot
install-flatpak: install-zypper

update-flatpak: update-zypper
