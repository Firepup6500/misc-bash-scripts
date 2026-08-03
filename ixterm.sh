#!/usr/bin/env bash

lxterm "$@" &
xtermpid=$!

for _i in {0..10}; do
  # Code for getting an X window ID from a PID taken from: https://stackoverflow.com/a/44073873
  while IFS= read -r line; do
    if [[ "${line}" =~ (0x)([0-9a-z]+)([ ][- ][0-9]+[ ])([0-9]*) ]]; then
      winId="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
      pid="${BASH_REMATCH[4]}"
      if [[ "${pid}" -eq "${xtermpid}" ]]; then
        WIND_IDS+=("${winId}")
      fi
    fi
  done < <(wmctrl -lp)

  if [ "${#WIND_IDS[@]}" -gt 0 ]; then
    magick /usr/local/share/icons/xterm/terminal_16x16.xpm PNG:-|xseticon -id "${WIND_IDS[0]}" -
    break
  fi
  sleep 0.1
done
wait
