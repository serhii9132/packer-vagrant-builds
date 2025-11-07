#!/bin/bash

apt clean
dd if=/dev/zero of=/zerofile bs=1M
rm /zerofile