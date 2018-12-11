#!/bin/sh
set -e

mkdir -p /home/warrior/projects

if [ -e /home/warrior/projects/config.json ]; then
  echo "config file exists at /home/warrior/projects/config.json - ignoring environment variables!"
else
  echo "saving environment variables to config file at /home/warrior/projects/config.json"
  jq -n '{
    "downloader": env.DOWNLOADER,
    "http_password": env.HTTP_PASSWORD,
    "http_username": env.HTTP_USERNAME,
    "selected_project": env.SELECTED_PROJECT,
    "shared:rsync_threads": env.SHARED_RSYNC_THREADS,
    "warrior_id": env.WARRIOR_ID,
    "concurrent_items": env.CONCURRENT_ITEMS
  }' > /home/warrior/projects/config.json
fi