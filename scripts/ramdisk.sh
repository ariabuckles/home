#!/bin/sh
# Makes a ramdisk for development:
sudo mkdir -p /mnt/ramdisk
if ! grep -q ' /mnt/ramdisk ' /etc/fstab; then
  echo "# Aria: ramdisk for development:" | sudo tee -a /etc/fstab
  echo "tmpfs /mnt/ramdisk tmpfs defaults,nosuid,nodev,size=32g" | sudo tee -a /etc/fstab
fi
sudo mount -a
mkdir --mode=700 /mnt/ramdisk/src
mkdir -p ~/.src
ln -snf /mnt/ramdisk/src ~/src
