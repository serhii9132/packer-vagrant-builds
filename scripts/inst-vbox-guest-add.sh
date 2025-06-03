#!/bin/bash

ISO=/home/vagrant/VBoxGuestAdditions.iso
MNT_POINT=/mnt

sudo mount -o loop $ISO $MNT_POINT
sudo bash ${MNT_POINT}/VBoxLinuxAdditions.run

sudo usermod -aG vboxsf vagrant
sudo umount $MNT_POINT

rm $ISO