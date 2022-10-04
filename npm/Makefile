.PHONY: install update sync

ifndef OSNAME
OSNAME := $(shell ( . /etc/os-release 2>/dev/null && echo $$ID ) || uname -s)
endif

# Add params like --ignore-unknown here
ifeq "$(OSNAME)" "opensuse-tumbleweed"
# TODO(aria): Figure out better apparmor settings so we can run npm rather than npm16 here:
NPM := npm16
else
NPM := npm
endif

install:
	echo npm: $(NPM)
	cat package.json | jq -r '.dependencies | to_entries | .[] | .key + "@" + .value' | xargs $(NPM) install -g

update: install ;

sync: ;
