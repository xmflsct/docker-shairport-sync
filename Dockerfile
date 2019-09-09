FROM alpine:latest

ARG SHAIRPORT_VER

WORKDIR /

RUN apk --no-cache -U add --virtual .build-dependencies \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        curl \
  && mkdir /root/shairport-sync \
  && cd /root/shairport-sync \
  && curl -L -o ./shairport-sync.tar.gz https://github.com/mikebrady/shairport-sync/archive/$SHAIRPORT_VER.tar.gz \
  && tar -zxvf shairport-sync.tar.gz --strip-components=1 \
  && autoreconf -i -f \
  && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
  && make \
  && make install \
  && cp ./scripts/shairport-sync.conf /etc/shairport-sync.conf \
  && cd / \
  && apk del .build-dependencies \
  && apk add --no-cache \
        dbus \
        alsa-lib \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
  && rm -rf \
        /etc/ssl \
        /lib/apk/db/* \
        /root/shairport-sync

COPY start.sh /start

ENV AIRPLAY_NAME airplay

ENTRYPOINT [ "/start" ]
