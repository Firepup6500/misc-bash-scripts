#!/bin/env bash
read -r up _ < /proc/uptime
s=${up%.*}
d=$((s/86400))
h=$(((s%86400)/3600))
m=$(((s%3600)/60))
sec=$((s%60))
printf "UP: %03d:%02d:%02d:%02d\n" "$d" "$h" "$m" "$sec" > /tmp/uptime
