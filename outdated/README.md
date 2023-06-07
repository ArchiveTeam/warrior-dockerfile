The following was taken out of the repository README due to the Raspberry Dockerfiles being outdated. This could be moved back when Raspberry Dockerfiles are up to date.

## Alternative Platforms

### Raspberry Pi

You can build the container with the following command:

```bash
docker build --rm -t warrior-arm32v5:latest -f Dockerfile.raspberry .
```

The image needs a place to store the downloaded data as well as its
configuration.  Say you have a location suitable at /var/local/warrior
use the command below, otherwise update the data and config.json paths.

First, create an empty config.json if it doesn't exist.  Otherwise when you
mount the path with docker it will create it as a directory.

```bash
touch /var/local/warrior/config.json
```

Now start the container.

```bash
docker run \
  --volume /var/local/warrior/data:/data/data \
  --volume /var/local/warrior/config.json:/home/warrior/projects/config.json \
  --publish 8001:8001 \
  --restart unless-stopped \
  warrior-arm32v5:latest
```
