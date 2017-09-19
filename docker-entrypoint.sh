#!/bin/bash

set -e
DAS_DATA=/home/das/.das
CONFIG_FILE=das.conf

if [ -z $1 ] || [ "$1" == "dasd" ] || [ $(echo "$1" | cut -c1) == "-" ]; then
  cmd=dasd
  shift

  if [ ! -d $DAS_DATA ]; then
    echo "$0: DATA DIR ($DAS_DATA) not found, please create and add config.  exiting...."
    exit 1
  fi

  if [ ! -f $DAS_DATA/$CONFIG_FILE ]; then
    echo "$0: dasd config ($DAS_DATA/$CONFIG_FILE) not found, please create.  exiting...."
    exit 1
  fi

  chmod 700 "$DAS_DATA"
  chown -R das "$DAS_DATA"

  if [ -z $1 ] || [ $(echo "$1" | cut -c1) == "-" ]; then
    echo "$0: assuming arguments for dasd"

    set -- $cmd "$@" -datadir="$DAS_DATA"
  else
    set -- $cmd -datadir="$DAS_DATA"
  fi

  exec gosu das "$@"
elif [ "$1" == "das-cli" ] || [ "$1" == "das-tx" ]; then

  exec gosu das "$@"
else
  echo "This entrypoint will only execute dasd, das-cli and das-tx"
fi
