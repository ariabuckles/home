.PHONY: install update sync

# Add params like --ignore-unknown here
# TODO(aria): Figure out better apparmor settings so we can run npm rather than npm16 here:
NPM := npm16

install:
	cat package.json | jq -r '.dependencies | to_entries | .[] | .key + "@" + .value' | xargs $(NPM) install -g

update: install ;

sync: ;
