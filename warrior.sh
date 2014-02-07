#!/bin/sh

cd /home/warrior/warrior-code2
export DOCKER=1
exec /sbin/setuser warrior ./warrior-runner.sh >>/var/log/warrior.log 2>&1
