#!/bin/bash

ISO=/home/vagrant/VBoxGuestAdditions.iso
MNT_POINT=/mnt

sudo apt install -y build-essential perl dkms make gcc bzip2

sudo mount -o loop $ISO $MNT_POINT
sudo bash ${MNT_POINT}/VBoxLinuxAdditions.run

sudo usermod -aG vboxsf vagrant
sudo umount $MNT_POINT

rm $ISO