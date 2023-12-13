# Archive Team Warrior Dockerfile

<img alt="Warrior logo" src="https://wiki.archiveteam.org/images/f/f3/Archive_team.png" height="100px"><img alt="Docker logo" src="https://wiki.archiveteam.org/images/7/79/Docker_%28container_engine%29_logo.png" height="100px">

A Dockerfile for the [Archive Team Warrior](https://wiki.archiveteam.org/index.php?title=ArchiveTeam_Warrior)

Build, run, grab the container IP and access the web interface on port 8001.

## Getting Started

Available as a built image at `atdr.meo.ws/archiveteam/warrior-dockerfile`.

The following example:
- Runs the Warrior in the background
- Configures Warrior to automatically start it again after machine reboot
- And configures Watchtower to automatically update Warrior (optional, but recommended).

```bash
docker run --detach \
  --name watchtower \
  --restart=on-failure \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --label-enable --cleanup --interval 3600

docker run --detach \
  --name archiveteam-warrior \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=on-failure \
  --publish 8001:8001 \
  atdr.meo.ws/archiveteam/warrior-dockerfile
```

On Windows (CMD), replace `\` with `^` like so:

```bash
docker run --detach ^
  --name watchtower ^
  --restart=on-failure ^
  --volume /var/run/docker.sock:/var/run/docker.sock ^
  containrrr/watchtower --label-enable --cleanup --interval 3600

docker run --detach ^
  --name archiveteam-warrior ^
  --label=com.centurylinklabs.watchtower.enable=true ^
  --restart=on-failure ^
  --publish 8001:8001 ^
  atdr.meo.ws/archiveteam/warrior-dockerfile
```
On Windows (PowerShell), replace `\` (in the Linux example) with `` ` ``.

To easily access the Warrior's web interface of multiple containers, try binding a different port for each subsequent container by incrementing `--publish` in your `docker run` command for the Warrior like so:

```bash
docker run --detach \
  --env DOWNLOADER="your name" \
  --env SELECTED_PROJECT="auto" \
  --name archiveteam-warrior \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=on-failure \
  --publish 8002:8001 \
  atdr.meo.ws/archiveteam/warrior-dockerfile
```

## Configuration

Configuration of Warrior can be done in one of three ways:
- Manually via the web interface.
- Via environment variables.
- Or via a configuration file (`projects/config.json`).

### Manual Using the Web Interface

To access the web interface get the container IP from `docker inspect` and point your browser to `http://IP:8001`. If you are running this container on a headless machine, be sure to bind the docker container's port to a port on that machine (e.g. `-p 8001:8001`) so that you can access the web interface on your LAN.

You can stop and resume the Warrior with `docker stop` and `docker start`

### Using Environment Variables

If you don't mount a `projects/config.json` configuration, you can provide seed settings using
environment variables. Once a `projects/config.json` file exists, environment variables
will be ignored.

For example, to specify environment variables, modify your `docker run` command for the Warrior like so:

```bash
docker run --detach \
  --env DOWNLOADER="your name" \
  --env SELECTED_PROJECT="auto" \
  --name archiveteam-warrior \
  --label=com.centurylinklabs.watchtower.enable=true \
  --restart=on-failure \
  --publish 8001:8001 \
  atdr.meo.ws/archiveteam/warrior-dockerfile
```

### Configuration Mapping

| ENV                  | JSON key             | Example           | Default |
|----------------------|----------------------|-------------------|---------|
| DOWNLOADER           | downloader           |                   |         |
| HTTP_PASSWORD        | http_password        |                   |         |
| HTTP_USERNAME        | http_username        |                   |         |
| SELECTED_PROJECT     | selected_project     | `auto`, `tumblr`  |         |
| SHARED_RSYNC_THREADS | shared:rsync_threads |                   | `20`    |
| WARRIOR_ID           | warrior_id           |                   |         |
| CONCURRENT_ITEMS     | concurrent_items     |                   | `3`     |

## Other Ways to Run

### Kubernetes

Edit the environment variable `DOWNLOADER` inside `k8s-warrior.yml` and set it to your name. This name will be used on the leaderboards.

```bash
kubectl create namespace archive
kubectl apply -n archive -f k8s-warrior.yml
```

If everything works out you should be able to connect to any of your k8s' nodes IP on port 30163 to view.

You can build the image on other platforms by using [`docker buildx`](https://github.com/docker/buildx), e.g.:

```bash
docker buildx build -t <yourusername>/archive-team-warrior:latest --platform linux/arm/v7 --push .
```

### Docker Compose

First edit the `docker-compose.yml` file with any configuration keys (as described above). When configured to your liking, use `docker compose` to start both Warrior and Watchtower.

```bash
cd examples
docker compose up -d
```

### Podman Compose

Podman Compose works almost identically to Docker's version but watchtower is not the recommended auto-update method.  To achive a similar effect:
#### One Time Setup
1. (as root) Set up the base systemd unit file for containers:
`sudo /usr/local/bin/podman-compose systemd --action create-unit`
1. (as your user) Configure the auto-update timer:
`systemctl --user enable --now podman-auto-update.timer`
1. (as your user) Create your directory to hold compose files:
`mkdir -p ~/containers`

#### For each container:
1. Set up a directory to hold the container and other files:  
`mkdir -p ~/containers/archiveteam; cd ~/containers/archiveteam`
2. Create `container-compose.yml` in the new directory:  
```
version: "3"
services:
  archiveteam:
    image: atdr.meo.ws/archiveteam/warrior-dockerfile
    container_name: archiveteam
    ports:
      - "8001:8001"
    restart: unless-stopped
    env_file: .env
    labels:
      - "io.containers.autoupdate=registry"
```
3. Create the `.env` file in the same directory with your configuration, using the Configuration Mapping fields above:
```
DOWNLOADER=
HTTP_USERNAME=
HTTP_PASSWORD=
SELECTED_PROJECT=auto
CONCURRENT_ITEMS=
```
4. Test the config with `podman-compose up`
5. If everything goes well, Ctrl-C the process and run `podman-compose down` to clean up
6. Register the container with systemctl: `podman-compose systemd -a register`
7. Enable the container to start on boot and start it right now with `systemctl --user enable --now podman-compose@archiveteam`
 
