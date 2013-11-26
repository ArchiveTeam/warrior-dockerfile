FROM ubuntu

MAINTAINER Filippo Valsorda <fv@filippo.io>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update  # 2013-11-22

RUN apt-get install -y language-pack-en
RUN update-locale LANG=en_US.UTF-8

RUN apt-get install -y unattended-upgrades
RUN yes | dpkg-reconfigure -plow unattended-upgrades

RUN apt-get install -y joe less wget

# ArchiveTeam Warrior

RUN apt-get install -y python-pip git pciutils sudo net-tools isc-dhcp-client python-software-properties wget
RUN apt-add-repository -y ppa:archiveteam/wget-lua && apt-get update
RUN apt-get install -y wget-lua

RUN useradd warrior
RUN echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /home/warrior && chown warrior: /home/warrior

RUN (cd /home/warrior && sudo -u warrior git clone https://github.com/ArchiveTeam/warrior-code2.git)
# RUN (cd /home/warrior/warrior-code2 && sudo -u warrior DOCKER=1 ./boot.sh)

EXPOSE 8001
CMD ["/bin/bash", "-c", "(cd /home/warrior/warrior-code2 && sudo -u warrior DOCKER=1 ./boot.sh && sudo -u warrior DOCKER=1 ./warrior-runner.sh)"]
