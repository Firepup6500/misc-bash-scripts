#!/usr/bin/env bash

cargo clippy --message-format=short 2>&1|sort -t: -k1,1n -k2,2n -k3,3n|grep -F -- "$1:"
