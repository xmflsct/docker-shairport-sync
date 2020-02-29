FROM alpine:latest AS builder

ARG SHAIRPORT_VER

RUN apk add --update \
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
    && curl -L -o /shairport-sync.tar.gz https://github.com/mikebrady/shairport-sync/archive/$SHAIRPORT_VER.tar.gz \
    && tar -zxvf /shairport-sync.tar.gz \
    && cd /shairport-sync-$SHAIRPORT_VER \
    && autoreconf -i -f \
    && ./configure \
         --prefix=/build \
         --with-alsa \
         --with-soxr \
         --with-avahi \
         --with-ssl=openssl \
    && make \
    && make install

FROM alpine:latest

RUN apk add --no-cache \
      dbus \
      alsa-lib \
      libdaemon \
      popt \
      libressl \
      soxr \
      avahi \
      libconfig

COPY --from=builder /build/bin/shairport-sync /usr/local/bin/shairport-sync

COPY ./data/start.sh ./data/shairport-sync.conf /shairport/

ENV AIRPLAY_NAME airplay

ENTRYPOINT [ "/shairport/start.sh" ]
