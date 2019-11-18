# ========================
# Top-level commands
# ========================

.PHONY: make install workspace admin update
make: install
workspace: admin install
admin: install-homebrew install-crontabs install-sudoers
	@echo admin installed
install: install-npm install-dotfiles install-prefs
	@echo installed
update: update-prefs update-dotfiles
	@echo updated


# ========================
# Definitions / Programs
# ========================

BREW=/usr/local/bin/brew


# ========================
# Admin (dependencies which require admin privileges)
# ========================

.PHONY: install-homebrew
install-homebrew:
ifeq ("$(wildcard $(BREW))","")
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
	${BREW} analytics off
	${BREW} update
	${BREW} bundle # installs deps in Brewfile

.PHONY:install-crontabs
install-crontabs:
	# Run .ensure-permissions.sh every 4 hours
	echo "0 */4 * * * zsh '$(shell pwd)/.ensure-permissions.sh'" | sudo crontab -u root -
	echo "0 */3 * * * zsh 'cd $(shell pwd) && make update'" | sudo crontab -u aria -

.PHONY:install-sudoers
install-sudoers:
	find sudoers.d -type f -print0 | sudo xargs -0 -I% cp % /private/etc/sudoers.d


# ========================
# Dependencies
# ========================

.PHONY: install-npm
install-npm:
	# Install package.json dependencies globally using jq from brew
	cat package.json | jq -r '.dependencies | to_entries | .[] | .key + "@" + .value' | xargs npm install -g

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
	mkdir -p ~/shell
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -tI% ln -s -F "`pwd`/%" ~
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -tI% ln -s -F "`pwd`/%" ~/shell/

.PHONY: copy-npmrc update-npmrc
# We do this so that the npmrc in git doesn't have the registry token
copy-npmrc:
	cp npmrc .npmrc
update-npmrc:
	cat .npmrc | grep -iv 'authtoken' | sed "s|$$HOME|\\\$${HOME}|"> npmrc


# ========================
# Prefs for GUI programs
# ========================

update-prefs:
	defaults export com.apple.Terminal - > terminal.plist
	plutil -convert xml1 ~/Library/Colors/NSColorPanelSwatches.plist -o color-swatches.plist

install-prefs:
	defaults import com.apple.Terminal terminal.plist
	plutil -convert binary1 color-swatches.plist -o ~/Library/Colors/NSColorPanelSwatches.plist


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
