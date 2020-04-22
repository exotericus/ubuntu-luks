#!/bin/bash
sgdisk -Z /dev/sda
sgdisk -n=1:0+512M /dev/sda
sgdisk -n=1:0+512M /dev/sda
sgdisk -n=3:0:0 /dev/sda
sudo cryptsetup luksFormat --hash=sha512 --key-size=512 --cipher=aes-xts-plain64 --verify-passphrase /dev/sda3
sudo cryptsetup luksOpen /dev/sda3 CryptDisk

#Setup LVM on /dev/mapper/CryptDisk
sudo pvcreate /dev/mapper/CryptDisk
sudo vgcreate ubuntu-vg /dev/mapper/CryptDisk
sudo lvcreate -n swap -L 2G ubuntu-vg
sudo lvcreate -n var -L 2G ubuntu-vg
sudo lvcreate -n log -L 2G ubuntu-vg
sudo lvcreate -n audit -L 2G ubuntu-vg
sudo lvcreate -n tmp -L 10G ubuntu-vg
sudo lvcreate -n root -L 10G ubuntu-vg
sudo lvcreate -n home -l +100%FREE ubuntu-vg
