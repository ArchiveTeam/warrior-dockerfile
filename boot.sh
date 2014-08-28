#!/bin/sh

cd /home/warrior/warrior-code2
sudo -u warrior DOCKER=1 TERM=dumb ./boot.sh 2>&1 | sudo tee /var/log/warrior-boot.log
