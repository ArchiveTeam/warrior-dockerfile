import json
import os
import subprocess

config = {
    'downloader': os.getenv('DOWNLOADER', ''),
    'http_username': os.getenv('HTTP_USERNAME', ''),
    'http_password': os.getenv('HTTP_PASSWORD', ''),
    'selected_project': os.getenv('SELECTED_PROJECT', ''),
    'shared:rsync_threads': os.getenv('SHARED_RSYNC_THREADS', ''),
    'warrior_id': os.getenv('WARRIOR_ID', ''),
    'concurrent_items': os.getenv('CONCURRENT_ITEMS', ''),
}

with open('projects/config.json', 'w') as fp:
    json.dump(config, fp)

subprocess.run([
    "run-warrior3",
    "--projects-dir",
    "/home/warrior/projects",
    "--data-dir",
    "/home/warrior/data",
    "--warrior-hq",
    "https://warriorhq.archiveteam.org",
    "--port",
    "8001",
    "--real-shutdown"
])
