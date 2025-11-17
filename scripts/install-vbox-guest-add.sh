#!/bin/bash

MNT_POINT=/mnt

apt install -y build-essential perl dkms make gcc bzip2

mount -o loop $ISO_PATH $MNT_POINT
bash ${MNT_POINT}/VBoxLinuxAdditions.run

if [[ -n $SUDO_USER ]]; then
    usermod -aG vboxsf $SUDO_USER
fi

umount $MNT_POINT

rm $ISO_PATH