#!/bin/bash

rm -f /etc/ssh/ssh_host_*
apt -y autoremove --purge
apt -y clean
apt -y autoclean

if [ "$(command -v cloud-init)" ]; then
    cloud-init clean --logs --machine-id --seed
else
    truncate -s 0 /etc/machine-id
fi