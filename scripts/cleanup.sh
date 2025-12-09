#!/bin/bash

rm -f /etc/ssh/ssh_host_*
apt -y autoremove --purge
apt -y clean
apt -y autoclean

truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

if [ "$(command -v cloud-init)" ]; then
    cloud-init clean --logs --seed
fi