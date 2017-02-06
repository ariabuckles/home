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
install: decrypt
	ls -A | grep '^\.' | xargs -I% ln -s "`pwd`/%" ~

reinstall: decrypt
	ls -A | grep '^\.' | xargs -I% ln -s -F "`pwd`/%" ~

copy-only:
	ls -A | grep '^\.' | xargs -I% ln -s -F "`pwd`/%" ~


# Encrypts
encrypt: setup-viridium encrypt-secrets encrypt-keychain
decrypt: setup-viridium decrypt-secrets decrypt-keychain

setup-viridium:
	ln -s -F "`pwd`/.viridium.json" ~

decrypt-secrets: npmutils
	-mv ~/.secrets.env ~/.secrets.env.bak
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -d -in secrets.env -out ~/.secrets.env -pass stdin

encrypt-secrets: npmutils
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -in ~/.secrets.env -out secrets.env -pass stdin

decrypt-keychain: npmutils
	./node_modules/.bin/viridium home.keychain | openssl aes-256-cbc -d -in home.keychain -out ~/Library/Keychains/home.keychain -pass stdin

encrypt-keychain: npmutils
	./node_modules/.bin/viridium home.keychain | openssl aes-256-cbc -out home.keychain -in ~/Library/Keychains/home.keychain -pass stdin

