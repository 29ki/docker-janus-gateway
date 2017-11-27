#!/usr/bin/env bash
set -e

# expand environment variables in config
if [ "$1" = 'janus' ]; then
  for f in /usr/local/etc/janus/*.cfg; do
    envsubst < "$f" > /tmp/subst
    mv /tmp/subst "$f"
  done
fi

if [ "$1" = 'janus' ] && [ "$(id -u)" = '0' ]; then
  mkdir -p /usr/local/share/janus/demos/voicemail
  chown -R janus /usr/local/share/janus/demos/voicemail

  exec gosu janus "$@"
fi

exec "$@"
