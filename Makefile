install: decrypt
	ls -A | grep '^\.' | xargs -I% ln -s "`pwd`/%" ~

reinstall: decrypt
	ls -A | grep '^\.' | xargs -I% ln -s -F "`pwd`/%" ~

npmutils:
	npm install viridium

decrypt: npmutils
	-mv ~/.secrets.env ~/.secrets.env.bak
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -d -in secrets.env -out ~/.secrets.env -pass stdin

encrypt: npmutils
	./node_modules/.bin/viridium secrets.env | openssl aes-256-cbc -in ~/.secrets.env -out secrets.env -pass stdin

