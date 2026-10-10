#!/usr/bin/env bash

ArchipelagoDir="$HOME/programs/Archipelago/"
Binary=${0##*/}

if [ -x "$ArchipelagoDir/$Binary" ];then
  exec "$ArchipelagoDir/$Binary" "$@"
else
  printf 'Error: %s is not a valid Archipelago executable\n' "$Binary" >&2
  exit 1
fi
