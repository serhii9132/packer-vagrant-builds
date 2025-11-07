#!/bin/bash

ISO=/root/VBoxGuestAdditions.iso
MNT_POINT=/mnt

apt install -y build-essential perl dkms make gcc bzip2

mount -o loop $ISO $MNT_POINT
bash ${MNT_POINT}/VBoxLinuxAdditions.run

usermod -aG vboxsf root
umount $MNT_POINT

rm $ISO