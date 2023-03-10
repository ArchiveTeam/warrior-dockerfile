FROM atdr.meo.ws/archiveteam/grab-base

RUN useradd -m warrior && echo "warrior ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ENV PATH="/home/warrior/.local/bin:${PATH}"
WORKDIR /home/warrior
USER warrior

RUN mkdir data projects && ln -fs /usr/local/bin/wget-lua /home/warrior/data/wget-at
COPY --from=atdr.meo.ws/archiveteam/wget-lua:v1.20.3-at-gnutls /wget /home/warrior/data/wget-at-gnutls

RUN git clone --depth 1 --recurse-submodules https://github.com/ArchiveTeam/warrior-code2.git

COPY --chown=warrior:warrior start.py .

EXPOSE 8001
STOPSIGNAL SIGINT

ENTRYPOINT [ "python", "start.py" ]
HEALTHCHECK --interval=5s --timeout=3s CMD /home/warrior/data/wget-at -nv -t1 'http://localhost:8001/index.html' -O /dev/null || exit 1
