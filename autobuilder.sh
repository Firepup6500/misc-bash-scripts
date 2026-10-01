#!/usr/bin/env bash

line=0
parent_dir="$(pwd)"
while IFS='#' read -r name dir cmds_str extra; do
  line=$(( ++line ))
  if [[ -n "$extra" ]];then
    printf 'Error: Extra #%ss in command line for %s on line %d\n' "'" "$name" "$line" >&2
    continue
  elif [[ -z "$name" || -z "$dir" || -z "$cmds_str" ]];then
    printf 'Error: Not enough #%ss in command line (or a field was blank) on line %d\n' "'" "$line" >&2
    continue
  fi
  # shellcheck disable=SC2016 # We don't want `%s` to expand, thanks shellcheck.
  printf 'Now building %s from %s with commands `%s`\n' "$name" "$dir" "$cmds_str"
  IFS=';' read -ra cmds <<< "$cmds_str"
  if ! cd "$dir" &>/dev/null;then
    printf 'Error: Cannot cd into %s to build %s, skipping\n' "$dir" "$name" >&2
    continue
  fi
  for cmd in "${cmds[@]}";do
    $cmd
    err=$?
    if [[ $err != 0 ]];then
      # shellcheck disable=SC2016 # We don't want `%s` to expand, thanks shellcheck.
      printf 'Error: Running comamnd `%s` while trying to build %s failed (code %d)\n' "$cmd" "$name" $err >&2
      break
    fi
  done
  if ! cd "$parent_dir" &>/dev/null;then
    printf 'Error: Parent directory (%s) has gone missing! Aborting!\n' "$parent_dir" >&2
    exit 1
  fi
done < ./build-commands.txt
