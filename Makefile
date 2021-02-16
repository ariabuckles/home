# TODO(aria): Need to make ariashell subdirectories (.local etc.) from here

# ========================
# Top-level commands
# ========================

.PHONY: make install workspace admin update
make: install
workspace: admin install
admin: create-users install-brew install-crontabs install-sudoers
	@echo admin installed
install: install-dotfiles install-npm install-prefs install-directories
	@echo installed
update: update-prefs update-dotfiles
	@echo updated


# ========================
# Definitions / Programs
# ========================
OS=$(shell uname -s)


# ========================
# Admin (dependencies which require admin privileges)
# ========================

.PHONY: create-users
create-users:
	sudo zsh ./create-user.sh ariashell

.PHONY: install-brew
install-brew:
ifeq ("$(shell which brew)","")
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
endif
	brew analytics off
	brew update
	brew bundle # installs deps in Brewfile
	xattr -r -d com.apple.quarantine /Applications/Chromium.app # Unquarantine chromium
	xattr -r -d com.apple.quarantine /usr/local/bin/op # Unquarantine 

.PHONY: install-crontabs
install-crontabs:
	# Run .ensure-permissions.sh every 4 hours
	echo "0 */4 * * * zsh '$(shell pwd)/.ensure-permissions.sh'" | sudo crontab -u root -
	echo "0 */3 * * * zsh -c 'cd $(shell pwd) && make update >/dev/null'" | sudo crontab -u aria -
	sudo cp dev.buckles.aria.launchd.unmanage-chrome.plist /Library/LaunchDaemons
	-sudo launchctl unload -w /Library/LaunchDaemons/dev.buckles.aria.launchd.unmanage-chrome.plist
	sudo launchctl load -w /Library/LaunchDaemons/dev.buckles.aria.launchd.unmanage-chrome.plist


.PHONY: install-sudoers
install-sudoers:
	find sudoers.d -type f -print0 | sudo xargs -0 -I% cp % /private/etc/sudoers.d


# ========================
# Dependencies
# ========================

.PHONY: install-npm
# TODO(aria): remove .config directory if non-symlink first.
install-npm: install-dotfiles
	# Install package.json dependencies globally using jq from brew
	cat package.json | jq -r '.dependencies | to_entries | .[] | .key + "@" + .value' | xargs npm14 install -g

.PHONY: install-npm
update-npm:
	@echo "Please update npm manually for now :( <3"


# ========================
# Dotfiles
# ========================

.PHONY: install-dotfiles update-dotfiles
install-dotfiles: copy-npmrc link-dotfiles
update-dotfiles: update-npmrc

.PHONY: link-dotfiles
link-dotfiles:
	mkdir -p ~/.config
	ls -A | grep '^\.' | grep -v '^\.git$$' | grep -v '^\.config' | xargs -tI% ln -sfn "`pwd`/%" ~
	ls -A .config | xargs -tI% ln -sfn "`pwd`/.config/%" ~/.config/
	mkdir -p ~/shell
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -tI% ln -sfn "`pwd`/%" ~/shell/

.PHONY: copy-npmrc update-npmrc
# We do this so that the npmrc in git doesn't have the registry token
copy-npmrc:
	cp npmrc .npmrc
update-npmrc:
	cat .npmrc | grep -iv 'authtoken' | sed "s|$$HOME|\\\$${HOME}|"> npmrc

.PHONY: install-directories
install-directories:
	mkdir -p ~/.local
	mkdir -p ~/shell/.local


# ========================
# Prefs for GUI programs
# ========================

.PHONY: update-prefs
update-prefs:
	command -v dconf > /dev/null && dconf dump / > .config/dconf/aria.txt || true
	test -e ~/Library/Preferences/com.apple.Terminal.plist && defaults export com.apple.Terminal - > terminal.plist || true
	test -e ~/Library/Colors/NSColorPanelSwatches.plist && plutil -convert xml1 ~/Library/Colors/NSColorPanelSwatches.plist -o color-swatches.plist || true
	test -e ~/Library/Preferences/com.google.Chrome.plist && plutil -extract NSUserKeyEquivalents json ~/Library/Preferences/com.google.Chrome.plist -r -o chrome-keybinds.plist || true
	test -e ~/Library/Preferences/org.chromium.Chromium.plist && plutil -extract NSUserKeyEquivalents json ~/Library/Preferences/org.chromium.Chromium.plist -r -o chromium-keybinds.plist || true

.PHONY: install-prefs
install-prefs:
	test -e ~/Library/Preferences/ && defaults import com.apple.Terminal terminal.plist || true
	test -e ~/Library/Colors/ && plutil -convert binary1 color-swatches.plist -o ~/Library/Colors/NSColorPanelSwatches.plist || true
	test -e ~/Library/Preferences/com.google.Chrome.plist && plutil -replace NSUserKeyEquivalents -json "$$(cat chrome-keybinds.plist)" ~/Library/Preferences/com.google.Chrome.plist || true
	test -e ~/Library/Preferences/org.chromium.Chromium.plist && plutil -replace NSUserKeyEquivalents -json "$$(cat chromium-keybinds.plist)" ~/Library/Preferences/org.chromium.Chromium.plist || true


# ========================
# Filesystem overrides
# ========================
.PHONY: install-system-files
install-system-files:
	fd --hidden --type=d . '@' | sed 's:^.::' | sudo xargs mkdir -p
	fd --hidden --type=f . '@' | sed 's:^.::' | sudo xargs -I% cp -p @% /%

.PHONY: install-user-files
install-user-files:
	fd --hidden --type=d . '~' | sed 's:^.::' | xargs -I% mkdir -p $$HOME/%
	fd --hidden --type=f . '~' | sed 's:^.::' | xargs -I% cp -p '~'% $$HOME/%

# ========================
# Secrets (currently unused)
# ========================

encrypt: setup-viridium encrypt-secrets encrypt-keychain
decrypt: setup-viridium decrypt-secrets decrypt-keychain

setup-viridium:
	ln -s -F "`pwd`/.viridium.json" ~

# TODO: make .secrets.env local to this file
decrypt-secrets: npmutils
	-mv ~/.secrets.env ~/.secrets.env.bak
	~/bin/viridium secrets.env | openssl aes-256-cbc -d -in secrets.env -out ~/.secrets.env -pass stdin

encrypt-secrets: npmutils
	~/bin/viridium secrets.env | openssl aes-256-cbc -in ~/.secrets.env -out secrets.env -pass stdin

decrypt-keychain: npmutils
	~/bin/viridium home.keychain | openssl aes-256-cbc -d -in home.keychain -out ~/Library/Keychains/home.keychain -pass stdin

encrypt-keychain: npmutils
	~/bin/viridium home.keychain | openssl aes-256-cbc -out home.keychain -in ~/Library/Keychains/home.keychain -pass stdin


# Write protect a file:
# sudo chflags schg fileName
# Un-write protect:
# sudo chflags noschg resume.txt
