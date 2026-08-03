#!/usr/bin/env bash
if [ -d .git-hooks ]; then
  printf 'Hooks!\n'
else
  printf "No git hooks found in the current directory to link.\n"
fi
