#!/bin/bash
timedatectl set-ntp true
reflector --country Poland --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
wipefs -a /dev/nvme0n1
echo -e "g\nn\n1\n\n+512M\nt\n1\n1\nn\n2\n\n\nw" | fdisk /dev/nvme0n1
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
pacstrap -K /mnt base linux linux-firmware grub efibootmgr git sudo nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt bash <<EOF
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m -G wheel natek
passwd -d natek
passwd -d root
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cd /home/natek
sudo -u natek git clone https://github.com
cd Arch-Hyprland
chmod +x install.sh
sudo -u natek ./install.sh
EOF
echo "GOTOWE - WPISZ REBOOT"
