#!/usr/bin/env bash

for i in *;do
  if cd "$i" &> /dev/null;then
    printf "pulling %s...\n" "$i"
    git pull
    cd ..
  fi
done
