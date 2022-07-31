# System vars
ifndef OSNAME
	OSNAME := $(shell ( . /etc/os-release 2>/dev/null && echo $$ID ) || uname -s)
endif

ifeq "$(OSNAME)" "Darwin"
	SUDO := sudo --login --set-home sh -c
	SU := su -l
else
	SUDO := su --login --pty -c
	SU := su --login --pty
endif

# Find subsystems based on subdirectories:
SUBDIRS := $(subst /,,$(dir $(wildcard */)))
INSTALL_TARGETS := $(patsubst %,install-%,$(SUBDIRS))
UPDATE_TARGETS := $(patsubst %,update-%,$(SUBDIRS))
SYNC_TARGETS := $(patsubst %,sync-%,$(SUBDIRS))

# Mark all targets as always needing a rerun:
.PHONY: install update root-install user-install root-update user-update root-sync user-sync
.PHONY: $(INSTALL_TARGETS) $(UPDATE_TARGETS) $(SYNC_TARGETS)

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
	# Elevating to root to install root configuration:
	$(SUDO) "cd '$$PWD' && $(MAKE) install-$(OSNAME) install-fsroot install-zypper install-homebrew install-flatpak"
	# Installed root settings

user-install:
	# Dropping to user privileges:
	$(SU) aria -c "cd '$$PWD' && $(MAKE) install-config install-homedir install-npm"
	# Installed user settings

# Update:
root-update:
	# Elevating to root to update root programs:
	$(SUDO) "cd '$$PWD' && $(MAKE) update-$(OSNAME) update-fsroot update-zypper update-homebrew update-flatpak"
	# Updated root software

user-update:
	# Dropping to user privileges:
	$(SU) aria -c "cd '$$PWD' && $(MAKE) update-config update-homedir update-npm"
	# Updated user software

# Sync:
root-sync: sync-$(OSNAME) sync-fsroot sync-zypper sync-homebrew sync-flatpak
	@echo "Synced root settings"

user-sync: sync-config sync-homedir sync-npm
	@echo "Synced user settings"

# Subtargets for specific directory subsystems:

$(INSTALL_TARGETS):
	make -C $(subst install-,,$@) install

$(UPDATE_TARGETS):
	make -C $(subst update-,,$@) update

$(SYNC_TARGETS):
	make -C $(subst sync-,,$@) sync

# OSNAME target does nothing unless it's an install/update/sync target above
# Create it so we don't error if it's not a directory
install-$(OSNAME):
update-$(OSNAME):
sync-$(OSNAME):

# Targets that have order dependencies:
install-zypper: install-fsroot
install-flatpak: install-zypper
install-npm: install-config

update-flatpak: update-zypper
