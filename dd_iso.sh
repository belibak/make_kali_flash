#!/bin/bash
if [ -z $1 ]
then
	echo "Usage: dd_iso.sh image.iso /dev/sdb"
elif [ -z $2 ]
then
	sudo fdisk -l
	echo "Usage: dd_iso.sh image.iso /dev/sdb"	
else
	chk=$(./check.py $2)
	if [ $chk -eq "1" ]
	then
		echo "I cant\`t write into $2 device"
		exit 1
	else
		echo "$2 checking ok..."
	fi
	#echo "Realy make changes on $2? [y/n]:"
	read -p "Realy make changes on $2? [y/n]: " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		sudo dd if=$1 of=$2 bs=1024 status=progress
		sudo echo -e "n\np\n3\n""\n""\nw" | fdisk $2
		echo "Making crypted persistence partition."
		./mk_crypt_partition.sh "$2"3
	else
		exit 1
	fi
fi

