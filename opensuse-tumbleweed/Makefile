.PHONY: install update sync

install:
	test $$(id -u) = 0 # Ensure we're running as root
	zypper install --no-recommends rsync
	rsync -rlp vars.d /etc/zypp/
	rsync -rlp --delete-after repos.d /etc/zypp/

update:
	test $$(id -u) = 0 # Ensure we're running as root
	# Tumbleweed has trouble maintaining the symlink for /usr/share/dict/words:
	test ! -e /usr/share/dict/words && test -e /usr/share/dict/american && ln -s /usr/share/dict/american /usr/share/dict/words

sync:
	rsync -rlp --delete /etc/zypp/vars.d .
	rsync -rlp --delete /etc/zypp/repos.d .
