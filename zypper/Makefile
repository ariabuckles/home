.PHONY: install update sync
.PHONY: ensure-is-root install-repos

# Add params like --ignore-unknown here
ZYPPER := zypper

ensure-is-root:
	test $$(id -u) = 0 # Ensure we're running as root

install-repos: ensure-is-root
	$(ZYPPER) install --no-recommends rsync
	rsync -rlp vars.d /etc/zypp/
	rsync -rlp --delete-after repos.d /etc/zypp/
	zypper modifyrepo --all --no-refresh --gpgcheck-strict

install: ensure-is-root install-repos
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install

update: ensure-is-root
	$(ZYPPER) refresh
	$(ZYPPER) dup --allow-vendor-change
	-$(ZYPPER) ps -s

sync:
	rsync -rlp --delete /etc/zypp/vars.d .
	rsync -rlp --delete /etc/zypp/repos.d .
