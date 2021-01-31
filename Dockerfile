# wget-at

ARG TLSTYPE=openssl
FROM atdr.meo.ws/archiveteam/wget-lua:v1.20.3-at-${TLSTYPE} AS wget

# Production

FROM python:3.9.1-slim-buster

ENV LC_ALL=C
RUN echo deb http://deb.debian.org/debian buster-backports main contrib > /etc/apt/sources.list.d/backports.list
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io update
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io install rsync liblua5.1-0 libluajit-5.1-2 libidn11 lua-socket libpsl5
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io -t buster-backports install zstd libzstd-dev libzstd1
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io install git sudo

COPY --from=wget /wget /usr/local/bin/wget-lua
RUN chmod +x /usr/local/bin/wget-lua

RUN useradd -m warrior
RUN echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ENV PATH="/home/warrior/.local/bin:${PATH}"
WORKDIR /home/warrior
USER warrior

RUN pip3 install requests seesaw warcio zstandard

RUN mkdir data
RUN mkdir projects

RUN git clone --depth 1 --recurse-submodules https://github.com/ArchiveTeam/warrior-code2.git

COPY --chown=warrior:warrior start.py .

EXPOSE 8001
STOPSIGNAL SIGINT

CMD [ "python", "start.py" ]
