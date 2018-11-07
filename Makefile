make: install

workspace: nativeutils install


# Programs
BREW=/usr/local/bin/brew

nativeutils:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	${BREW} install node
	${BREW} install the_silver_searcher
	${BREW} install tig

npmutils:
	npm install viridium


# Env files
install: copy-npmrc decrypt install-prefs
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -I% ln -s "`pwd`/%" ~

update: encrypt update-prefs
	echo "update"

reinstall: decrypt
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -I% ln -s -F "`pwd`/%" ~

copy-only:
	ls -A | grep '^\.' | grep -v '^\.git$$' | xargs -I% ln -s -F "`pwd`/%" ~


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

install-prefs:
	defaults import com.apple.Terminal terminal.plist

# We do this so that the npmrc in git doesn't have the registry token
copy-npmrc:
	cp npmrc .npmrc


# Write protect a file:
# sudo chflags schg fileName
# Un-write protect:
# sudo chflags noschg resume.txt
