# Use phusion/baseimage as base image.
FROM phusion/baseimage:0.9.5

MAINTAINER Filippo Valsorda <fv@filippo.io>

# Set environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install dependencies
RUN apt-get install -y python-pip git pciutils sudo net-tools isc-dhcp-client python-software-properties wget
RUN apt-add-repository -y ppa:archiveteam/wget-lua && apt-get update
RUN apt-get install -y wget-lua

# Setup system for the warrior
RUN useradd warrior
RUN echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /home/warrior && chown warrior: /home/warrior

# Clone warrior code
RUN (cd /home/warrior && sudo -u warrior git clone -b docker https://github.com/ArchiveTeam/warrior-code2.git)

# Add the boot script (this wil install the actual warrior on boot)
RUN mkdir -p /etc/my_init.d
ADD boot.sh /etc/my_init.d/warrior-boot.sh

# Expose web interface port
EXPOSE 8001

# Add the warrior service entry for runit
RUN mkdir /etc/service/warrior
ADD warrior.sh /etc/service/warrior/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
