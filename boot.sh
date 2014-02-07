#!/bin/sh

cd /home/warrior/warrior-code2
sudo -u warrior DOCKER=1 ./boot.sh >>/var/log/warrior-boot.log 2>&1
