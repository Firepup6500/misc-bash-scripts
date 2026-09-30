#!/usr/bin/env bash

black -q "$@"
isort --profile black -q --nlb STDLIB --nlb THIRDPARTY --nlb FIRSTPARTY --nlb LOCALFOLDER "$@"
