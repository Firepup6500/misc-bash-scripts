#/bin/env bash
for i in {0..15}; do
  ixterm -title "Terminal $((i+1)) out of 16 - 16-terms.sh" &
  sleep 0.2
done
wait
