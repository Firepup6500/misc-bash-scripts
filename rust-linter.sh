#!/usr/bin/env bash

cargo clippy --message-format=short 2>&1 | grep -F -- "$1:"
