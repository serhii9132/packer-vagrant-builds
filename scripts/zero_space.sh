#!/bin/bash

sudo apt clean
sudo dd if=/dev/zero of=/zerofile bs=1M
sudo rm /zerofile