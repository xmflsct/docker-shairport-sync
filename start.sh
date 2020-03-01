#!/bin/sh

set -e

rm -rf /var/run
mkdir -p /var/run/dbus

dbus-uuidgen --ensure
dbus-daemon --system

avahi-daemon --daemonize --no-chroot

shairport-sync -c /shairport-sync.conf -a "$AIRPLAY_NAME" "$@"
