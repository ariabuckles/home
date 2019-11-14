make: install

workspace: homebrew install


# Programs
BREW=/usr/local/bin/brew

homebrew:
ifeq ("$(wildcard $(BREW))","")
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
	${BREW} analytics off
	${BREW} bundle # installs deps in Brewfile

npmutils:
	npm install


# Env files
install: copy-npmrc decrypt install-prefs link-dotfiles
	echo installed

update: encrypt update-prefs
	echo updated

reinstall: decrypt link-dotfiles

.PHONY: link-dotfiles
link-dotfiles:
	mkdir -p ~/shell
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -tI% ln -s -F "`pwd`/%" ~
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -tI% ln -s -F "`pwd`/%" ~/shell/

.PHONY:crontab
crontab:
	# Run .ensure-permissions.sh every 4 hours
	echo "0 */4 * * * zsh '$(shell pwd)/.ensure-permissions.sh'" | sudo crontab -

# Encrypts
encrypt: setup-viridium encrypt-secrets encrypt-keychain
decrypt: setup-viridium decrypt-secrets decrypt-keychain

setup-viridium:
	ln -s -F "`pwd`/.viridium.json" ~

# TODO: make .secrets.env local to this file
decrypt-secrets: npmutils
	-mv ~/.secrets.env ~/.secrets.env.bak
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -d -in secrets.env -out ~/.secrets.env -pass stdin

encrypt-secrets: npmutils
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -in ~/.secrets.env -out secrets.env -pass stdin

decrypt-keychain: npmutils
	./node_modules/.bin/viridium home.keychain | openssl aes-256-cbc -d -in home.keychain -out ~/Library/Keychains/home.keychain -pass stdin

encrypt-keychain: npmutils
	./node_modules/.bin/viridium home.keychain | openssl aes-256-cbc -out home.keychain -in ~/Library/Keychains/home.keychain -pass stdin

update-prefs:
	defaults export com.apple.Terminal - > terminal.plist
	plutil -convert xml1 ~/Library/Colors/NSColorPanelSwatches.plist -o color-swatches.plist

install-prefs:
	defaults import com.apple.Terminal terminal.plist
	plutil -convert binary1 color-swatches.plist -o ~/Library/Colors/NSColorPanelSwatches.plist


# We do this so that the npmrc in git doesn't have the registry token
copy-npmrc:
	cp npmrc .npmrc


# Write protect a file:
# sudo chflags schg fileName
# Un-write protect:
# sudo chflags noschg resume.txt
