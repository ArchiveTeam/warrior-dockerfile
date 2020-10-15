## A Dockerfile for the [ArchiveTeam Warrior](https://www.archiveteam.org/index.php?title=ArchiveTeam_Warrior)
<img alt="Warrior logo" src="https://www.archiveteam.org/images/f/f3/Archive_team.png" height="100px"><img alt="Docker logo" src="https://upload.wikimedia.org/wikipedia/commons/7/79/Docker_%28container_engine%29_logo.png" height="100px">

Build, run, grab the container IP and access the web interface on port 8001.

Available as a Trusted Build on the index as [`archiveteam/warrior-dockerfile`](https://index.docker.io/u/archiveteam/warrior-dockerfile/) so you can just

```
docker pull archiveteam/warrior-dockerfile
# run without -d to follow the warrior install process
# you will need to detach or stop-and-start the container.
# use -p to bind port 8001 on the docker container
# (default ip 172.17.0.x) to port 8001 on localhost.
docker run [-d] [-p 127.0.0.1:8001:8001] archiveteam/warrior-dockerfile
```

If you prefer to just run the process in the background, and automatically start it again after machine reboot, use this instead:

``` shell-interaction
docker run --detach \
  --publish 127.0.0.1:8001:8001 \
  --restart unless-stopped \
  archiveteam/warrior-dockerfile
```

To easily access the Warrior's web interface of multiple containers, try binding a different port for each subsequent container:

``` shell-interaction
docker run --detach \
  --publish 127.0.0.1:8002:8001 \
  --restart unless-stopped \
  archiveteam/warrior-dockerfile
```


### Configuration


#### Manual Using the Web Interface
To access the web interface get the container IP from `docker inspect` and point your browser to `http://IP:8001`. If you are running this container on a headless machine, be sure to bind the docker container's port to a port on that machine (e.g. `-p 8001:8001`) so that you can access the web interface on your LAN.

You can stop and resume the Warrior with `docker stop` and `docker start`


#### Using Environment Variables

If you don't mount a `projects.json` configuration, you can provide seed settings using
environment variables. Once a `projects.json` file exists, environment variables
will be ignored. Please note: This is currently not available in the Raspberry PI image.

##### Example:

```shell
  docker run \
      --detach \
      --env DOWNLOADER="your name" \
      --env SELECTED_PROJECT="auto" \
      --publish 8001:8001 \
      --restart unless-stopped \
      archiveteam/warrior-dockerfile
```

##### Mapping

| ENV                  | JSON key             | Example           | Default |
|----------------------|----------------------|-------------------|---------|
| DOWNLOADER           | downloader           |                   |         |
| HTTP_PASSWORD        | http_password        |                   |         |
| HTTP_USERNAME        | http_username        |                   |         |
| SELECTED_PROJECT     | selected_project     | `auto`, `tumblr`  |         |
| SHARED_RSYNC_THREADS | shared:rsync_threads |                   | `20`    |
| WARRIOR_ID           | warrior_id           |                   |         |
| CONCURRENT_ITEMS     | concurrent_items     |                   | `3`     |

## Raspberry Pi
You can build the container with the following command:
``` shell-interaction
docker build --rm -t warrior-arm32v5:latest -f Dockerfile.raspberry .
```

The image needs a place to store the downloaded data as well as its
configuration.  Say you have a location suitable at /var/local/warrior
use the command below, otherwise update the data and config.json paths.

First, create an empty config.json if it doesn't exist.  Otherwise when you
mount the path with docker it will create it as a directory.
``` shell-interaction
touch /var/local/warrior/config.json
```

Now start the container.
``` shell-interaction
docker run \
	--volume /var/local/warrior/data:/data/data \
	--volume /var/local/warrior/config.json:/home/warrior/projects/config.json \
	--publish 8001:8001 \
	--restart unless-stopped \
	warrior-arm32v5:latest
```

## Kubernetes

``` shell-interaction
kubectl create namespace archive
kubectl apply -n archive -f warrior.yml
```

If everything works out you should be able to connect to any of your k8s' nodes IP on port 30163 to view.

You can build the image on other platforms (e.g. Raspberry Pi here for example) by using [`docker buildx`](https://github.com/docker/buildx), e.g.:

``` shell-interaction
docker buildx build -t <yourusername>/archive-team-warrior:latest --platform linux/arm/v7 --push .
```
