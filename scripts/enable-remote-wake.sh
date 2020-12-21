#!/bin/zsh
set -euo pipefail
cat <<EOF | sudo tee /etc/systemd/system/aria-enable-remote-wake.service
[Unit]
Description=Turn on wake-on-wifi

[Service]
Type=oneshot
ExecStart=iw phy0 wowlan enable magic-packet

[Install]
WantedBy=multi-user.target
EOF
set -x
sudo systemctl daemon-reload
sudo systemctl enable aria-enable-remote-wake.service --now
systemctl status aria-enable-remote-wake.service
