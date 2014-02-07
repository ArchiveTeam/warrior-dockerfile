## A Dockerfile for the [ArchiveTeam Warrior](http://www.archiveteam.org/index.php?title=ArchiveTeam_Warrior)

![Warrior logo](http://www.archiveteam.org/images/thumb/f/f3/Archive_team.png/235px-Archive_team.png)
![Docker logo](https://upload.wikimedia.org/wikipedia/commons/7/79/Docker_%28container_engine%29_logo.png)

Build, run, grab the container IP and access the web interface on port 8001.

Available as a Trusted Build on the index as [`archiveteam/warrior-dockerfile`](https://index.docker.io/u/archiveteam/warrior-dockerfile/) so you can just

```
docker pull archiveteam/warrior-dockerfile
# run without -d to follow the warrior install process
# you will need to detach or stop-and-start the container
docker run [-d] archiveteam/warrior-dockerfile
```

To access the web interface get the conatiner IP from `docker inspect` and point your browser to `http://IP:8001`

You can stop and resume the Warrior with `docker stop` and `docker start`
