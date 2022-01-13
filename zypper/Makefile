.PHONY: install update sync
.PHONY: ensure-is-root install-vars install-repos

# Add params like --ignore-unknown here
ZYPPER := zypper

ensure-is-root:
	test $$(id -u) = 0 # Ensure we're running as root

install-vars: ensure-is-root
	mkdir -p /etc/zypp/vars.d
	for f in vars.d/*; do; eval "echo $$(cat $$f)" > /etc/zypp/$$f; done

install-repos: ensure-is-root install-vars
	rm -- /etc/repos.d/*
	for f in repos.d/*; do; cp $$f /etc/zypp/$$f; done
	zypper modifyrepo --all --no-refresh --gpgcheck-strict

install: ensure-is-root install-vars install-repos
	$(ZYPPER) refresh
	cat *.txt | grep -v '^#\|^$$' | xargs -t $(ZYPPER) install

update: ensure-is-root
	$(ZYPPER) refresh
	$(ZYPPER) dup --allow-vendor-change
	$(ZYPPER) ps -s

sync: ;
