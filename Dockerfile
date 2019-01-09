# Use phusion/baseimage as base image.
FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose web interface port
EXPOSE 8001

COPY get-wget-lua.sh /

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      autoconf \
      flex \
      gcc \
      git \
      isc-dhcp-client \
      jq \
      libgnutls28-dev \
      liblua5.1-0 \
      liblua5.1-0-dev \
      make \
      net-tools \
      pciutils \
      python \
      python-pip \
      python-setuptools \
      python3 \
      python3-pip \
      python3-setuptools \
      rsync \
      software-properties-common \
      sudo \
      wget \
  && chmod +x /get-wget-lua.sh && sync && bash -c "/get-wget-lua.sh" \
  && apt-get remove -y \
    autoconf \
    flex \
    gcc \
    libgnutls28-dev \
    liblua5.1-0-dev \
    make \
  && apt-get clean && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Setup system for the warrior
  && useradd warrior \
  && mkdir /home/warrior \
  && chown warrior: /home/warrior \
# Clone warrior code
 && cd /home/warrior \
 && sudo -u warrior git clone -b docker https://github.com/ArchiveTeam/warrior-code2.git \
# running as root and/or requiring sudo is a bad practice in docker containers,
# sadly sudo is hard-coded all over the place in `warrior-code2`
 && echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add the warrior service entry for runit
COPY warrior.sh /etc/service/warrior/run

# ENV to JSON
COPY env-to-json.sh /home/warrior

ENV DOWNLOADER=""
ENV HTTP_PASSWORD=""
ENV HTTP_USERNAME=""
ENV SELECTED_PROJECT=""
ENV SHARED_RSYNC_THREADS=""
ENV WARRIOR_ID=""
ENV CONCURRENT_ITEMS=""

# Add the boot script (this will install the actual warrior on boot)
COPY warrior-boot.sh /etc/my_init.d/
