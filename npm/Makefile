.PHONY: install update

# Add params like --ignore-unknown here
NPM := npm16

install:
	cat package.json | jq -r '.dependencies | to_entries | .[] | .key + "@" + .value' | xargs $(NPM) install -g

update: install ;
