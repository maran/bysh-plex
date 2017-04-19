FROM phusion/baseimage:0.9.21
MAINTAINER Animazing

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TERM xterm

RUN apt-get -q update && \
    apt-get install -qy curl wget ca-certificates procps && \
    echo "deb  https://downloads.plex.tv/repo/deb/ public main" > /etc/apt/sources.list.d/plexmediaserver.list && \
    wget -q https://downloads.plex.tv/plex-keys/PlexSign.key -O - | apt-key add - && \
    apt-get -q update && \
    apt-get install -qyo Dpkg::Options::='--force-confold' plexmediaserver

RUN apt-get install -y dbus avahi-daemon
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
RUN mkdir /etc/service/plex
COPY run /etc/service/plex/run
RUN chmod +x /etc/service/plex/run
RUN echo /config > /etc/container_environment/HOME

VOLUME /config
VOLUME /data

ENV HOME /config
EXPOSE 32400

CMD ["/sbin/my_init"]

