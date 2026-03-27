import json
import os
import subprocess
import shutil

DEFAULT_RUN_DIR = '/home/warrior'
WARRIOR_RUN_DIR = os.getenv('WARRIOR_RUN_DIR', DEFAULT_RUN_DIR)
CONFIG_FILE = os.path.join(WARRIOR_RUN_DIR, 'projects/config.json')

# copy data/projects from image to the custom run dir
if WARRIOR_RUN_DIR != DEFAULT_RUN_DIR:
    for dir_name in ['data', 'projects']:
        dst = os.path.join(WARRIOR_RUN_DIR, dir_name)
        src = os.path.join(DEFAULT_RUN_DIR, dir_name)
        shutil.copytree(src, dst)

try:
    with open(CONFIG_FILE, 'r') as fp:
        json.load(fp)
except Exception:
    config = {
        'downloader': os.getenv('DOWNLOADER', ''),
        'http_username': os.getenv('HTTP_USERNAME', ''),
        'http_password': os.getenv('HTTP_PASSWORD', ''),
        'selected_project': os.getenv('SELECTED_PROJECT', ''),
        'shared:rsync_threads': os.getenv('SHARED_RSYNC_THREADS', ''),
        'warrior_id': os.getenv('WARRIOR_ID', ''),
        'concurrent_items': os.getenv('CONCURRENT_ITEMS', ''),
    }
    with open(CONFIG_FILE, 'w') as fp:
        json.dump(config, fp)

subprocess.run(
    [
        "run-warrior3",
        "--projects-dir",
        os.path.join(WARRIOR_RUN_DIR, "projects"),
        "--data-dir",
        os.path.join(WARRIOR_RUN_DIR, "data"),
        "--warrior-hq",
        "https://warriorhq.archiveteam.org",
        "--port",
        "8001",
        "--real-shutdown"
    ],
    stdin=subprocess.DEVNULL
)
