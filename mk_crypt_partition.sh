#!/bin/bash
if [ -z $1 ]
then
	sudo fdisk -l
	echo "Enter device where make a new partition. like /dev/sdb3"
	read dev
else
	dev=$1
fi
crypt_usb="crypt_usb"
#sudo fdisk "$dev"
cryptsetup --verbose --verify-passphrase luksFormat "$dev"
cryptsetup luksOpen "$dev" $crypt_usb
mkfs.ext3 /dev/mapper/$crypt_usb
e2label /dev/mapper/$crypt_usb persistence
mkdir -p /mnt/$crypt_usb
mount /dev/mapper/$crypt_usb /mnt/$crypt_usb
echo "/ union" > /mnt/$crypt_usb/persistence.conf
umount /dev/mapper/$crypt_usb
cryptsetup luksClose /dev/mapper/$crypt_usb
