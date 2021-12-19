.PHONY: install update

install:
	test $$(id -u) = 0 # Ensure we're running as root
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	cat *.txt | grep -v '^#\|^$$' | xargs -t flatpak install -y --system flathub

update: ;
