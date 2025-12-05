#!/bin/bash

cp /tmp/regenerate_ssh_host_keys.service /etc/systemd/system/regenerate-ssh-host-keys.service
chown root:root /etc/systemd/system/regenerate-ssh-host-keys.service
#systemd daemon-reload
systemctl enable regenerate-ssh-host-keys.service
rm /tmp/regenerate_ssh_host_keys.service 