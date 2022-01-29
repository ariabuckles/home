.PHONY: install update sync

install:
	test $$(id -u) = 0 # Ensure we're running as root
	zypper install --no-recommends rsync
	rsync -rlp vars.d /etc/zypp/
	rsync -rlp --delete-after repos.d /etc/zypp/

update: ;

sync:
	rsync -rlp --delete /etc/zypp/vars.d .
	rsync -rlp --delete /etc/zypp/repos.d .
