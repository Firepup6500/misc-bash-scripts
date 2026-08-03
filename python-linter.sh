#!/usr/bin/env bash

pylint -ftext --exit-zero "$@" || exit "$?"
mypy --no-error-summary --follow-untyped-imports "$@" || true
