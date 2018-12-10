#!/bin/sh


/sbin/setuser warrior /home/warrior/env-to-json.sh

cd /home/warrior/warrior-code2
export DOCKER=1

echo "starting warrior"
exec /sbin/setuser warrior ./warrior-runner.sh >>/var/log/warrior.log 2>&1
