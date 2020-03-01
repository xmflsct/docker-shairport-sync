![GitHub Workflow Status](https://img.shields.io/github/workflow/status/xmflsct/docker-shairport-sync/Publish) ![Docker Image Version (latest by date)](https://img.shields.io/docker/v/xmflsct/shairport-sync) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/xmflsct/shairport-sync) 

Based on [shairport-sync](https://github.com/mikebrady/shairport-sync), this docker image follows the latest update from the source. Currently being used on a [Raspiberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/).

## Built with
```
--with-alsa
--with-soxr
--with-avahi
--with-mqtt-client
--with-ssl=openssl
```

## Run with
```
version: '3'
services:
  shairport-sync:
    container_name: shairport-sync
    restart: always
    network_mode: host
    devices:
      - /dev/snd
    environment:
      - AIRPLAY_NAME=YOUR-DECIDE
    volumes:
      - /YOUR-DIR/shairport-sync.conf:/shairport-sync.conf # Replace with your config file
    image: xmflsct/shairport-sync:latest
```
Sample configuration file can be found [here](https://github.com/mikebrady/shairport-sync/blob/master/scripts/shairport-sync.conf). For my configuration for [Raspiberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) sound out from HDMI 0, you can refer to the `data` folder.
