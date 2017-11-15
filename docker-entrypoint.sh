#!/bin/sh
set -e

if [ "$1" = 'janus' ] && [ "$(id -u)" = '0' ]; then
  mkdir -p /usr/local/share/janus/demos/voicemail
  chown -R janus /usr/local/share/janus/demos/voicemail
  exec gosu janus "$@"
fi

exec "$@"
