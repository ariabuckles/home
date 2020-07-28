#!/bin/zsh
set -euo pipefail
cat <<EOF | sudo tee /etc/X11/sessions/gnome-i3.desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Gnome i3
Comment=Custom i3 with gnome panel
Exec=gnome-session --session=gnome-i3
EOF
cat <<EOF | sudo tee /usr/share/gnome-session/sessions/gnome-i3.session
[GNOME Session]
Name=Gnome i3
RequiredComponents=gnome-panel;gnome-settings-daemon;
RequiredProviders=windowmanager;
DefaultProvider-windowmanager=i3
DefaultProvider-notifications=notify-osd
IsRunnableHelper=/usr/lib/gnome-session/gnome-session-check-accelerated
EOF
