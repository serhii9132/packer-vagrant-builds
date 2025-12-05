#!/bin/bash

rm -f /etc/ssh/ssh_host_*
apt -y autoremove --purge
apt -y clean
apt -y autoclean
cloud-init clean --logs --machine-id --seed