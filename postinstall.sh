#!/bin/bash
sudo mount /dev/ubuntu-vg/root /mnt
sudo mount /dev/ubuntu-vg/home /mnt/home # this is probably not necessary
sudo mount /dev/ubuntu-vg/tmp /mnt/tmp
sudo mount /dev/ubuntu-vg/var /mnt/var
sudo mount /dev/ubuntu-vg/log /mnt/var/log
sudo mount /dev/ubuntu-vg/audit /mnt/var/log/audit

sudo mount /dev/sda1 /mnt/boot
sudo mount --bind /dev /mnt/dev # I'm not entirely sure this is necessary
sudo mount --bind /run/lvm /mnt/run/lvm
#(Only if you're using EFI): 
sudo mount /dev/sda2 /mnt/boot/efi

echo '#!/bin/bash' >> /mnt/postinstall_chroot.sh
echo 'mount -t proc proc /proc' >> /mnt/postinstall_chroot.sh
echo 'mount -t sysfs sys /sys' >> /mnt/postinstall_chroot.sh
echo 'mount -t devpts devpts /dev/pts' >> /mnt/postinstall_chroot.sh
MYDISK=$(sudo blkid | grep LUKS | cut -d " " -f 2 | sed 's/\"//g')
echo "CryptDisk $MYDISK none luks,discard" >> /mnt/mydisk.txt
echo 'cat /mydisk.txt >> /etc/crypttab' >> /mnt/postinstall_chroot.sh
echo 'update-initramfs -k all -c' >> /mnt/postinstall_chroot.sh
echo 'update-grub' >> /mnt/postinstall_chroot.sh
echo 'exit' >> /mnt/postinstall_chroot.sh
chmod +x /mnt/postinstall_chroot.sh
sudo chroot /mnt

