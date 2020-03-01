FROM alpine:latest AS builder

ARG VERSION=3.3.6

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
      mosquitto-dev \
      curl

RUN curl -L -o /shairport-sync.tar.gz https://github.com/mikebrady/shairport-sync/archive/$VERSION.tar.gz
RUN tar -zxf /shairport-sync.tar.gz

WORKDIR /shairport-sync-$VERSION
RUN autoreconf -i -f
RUN ./configure \
      --prefix=/build \
      --with-alsa \
      --with-soxr \
      --with-avahi \
      --with-mqtt-client \
      --with-ssl=openssl
RUN make
RUN make install

FROM alpine:latest

RUN apk add --no-cache \
      dbus \
      alsa-lib \
#      libdaemon \
      popt \
      libressl \
      soxr \
      avahi \
      libconfig \
      mosquitto-clients

COPY --from=builder /build/bin/shairport-sync /usr/local/bin/shairport-sync

COPY ./start.sh /

ENTRYPOINT [ "/start.sh" ]
