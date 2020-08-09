#!/bin/zsh
# Makes a ramdisk for development:
sudo mkdir -p /media/user-backups
if ! grep -q ' /media/user-backups ' /etc/fstab; then
  echo "# Aria: user backup /dev/sda3 mount:" | sudo tee -a /etc/fstab
  echo "/dev/sda3 /media/user-backups ext4 rw,nosuid,nodev,noexec,user,users,auto,async" | sudo tee -a /etc/fstab
fi
sudo mount -a
