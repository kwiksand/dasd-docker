#!/bin/sh
set -e
DAS_DATA=/home/das/.das
cd /home/das/dasd

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for dasd"

  set -- dasd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "dasd" ]; then
  mkdir -p "$DAS_DATA"
  chmod 700 "$DAS_DATA"
  chown -R das "$DAS_DATA"

  echo "$0: setting data directory to $DAS_DATA"

  set -- "$@" -datadir="$DAS_DATA"
fi

if [ "$1" = "dasd" ] || [ "$1" = "das-cli" ] || [ "$1" = "das-tx" ]; then
  echo
  exec gosu das "$@"
fi

echo
exec "$@"
