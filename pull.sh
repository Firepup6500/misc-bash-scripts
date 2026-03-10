#!/bin/env bash
for i in $(\ls);do
  cd $i &> /dev/null
  if [[ "$?" == "0" ]];then
    printf "pulling $i...\n"
    git pull
    cd ..
  fi
done
