## A Dockerfile for the [ArchiveTeam Warrior](http://www.archiveteam.org/index.php?title=ArchiveTeam_Warrior)

![Warrior logo](http://www.archiveteam.org/images/thumb/f/f3/Archive_team.png/235px-Archive_team.png)
![Docker logo](https://upload.wikimedia.org/wikipedia/commons/7/79/Docker_%28container_engine%29_logo.png)

Build, run, grab the container IP and access the web interface on port 8001.

Available as a Trusted Build on the index as [`archiveteam/warrior-dockerfile`](https://index.docker.io/u/archiveteam/warrior-dockerfile/) so you can just

```
docker pull archiveteam/warrior-dockerfile
docker run archiveteam/warrior-dockerfile
```

**TODO**: use `supervisord`, make `cron` work and consider pre-installing the whole Warrior on build (or maybe not).
