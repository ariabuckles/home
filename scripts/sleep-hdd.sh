#!/bin/zsh
set -euo pipefail
cat <<EOF | sudo tee /etc/systemd/system/sleep-hdd.service
# Shut down the HDD in /dev/sda on startup
# (only used for backups)

[Unit]
Description=sleep HDD on startup

[Service]
Type=oneshot
ExecStart=$(sudo which hdparm) -q -S 3 -Y /dev/sda

[Install]
WantedBy=multi-user.target
EOF
set -x
sudo systemctl daemon-reload
sudo systemctl enable sleep-hdd.service --now
systemctl status sleep-hdd.service
