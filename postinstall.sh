#!/bin/bash
sudo mount /dev/ubuntu-vg/root /mnt
sudo mount /dev/ubuntu-vg/home /mnt/home # this is probably not necessary
sudo mount /dev/ubuntu-vg/tmp /mnt/tmp
sudo mount /dev/ubuntu-vg/var /mnt/var
sudo mount /dev/ubuntu-vg/log /mnt/var/log
sudo mount /dev/ubuntu-vg/audo /mnt/var/log/audit

sudo mount /dev/sda1 /mnt/boot
sudo mount --bind /dev /mnt/dev # I'm not entirely sure this is necessary
sudo mount --bind /run/lvm /mnt/run/lvm
#(Only if you're using EFI): 
sudo mount /dev/sda2 /mnt/boot/efi

sudo chroot /mnt
#From the chroot, mount a couple more things
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t devpts devpts /dev/pts

MYDISK=$(sudo blkid | grep LUKS | cut -d " " -f 2 | sed 's/\"//g')
echo CryptDisk $MYDISK none,luks,discard >> /etc/crypttab
#CryptDisk UUID=bd3b598d-88fc-476e-92bb-e4363c98f81d none luks,discard
#Lastly, rebuild some boot files.

update-initramfs -k all -c
update-grub
