#!/usr/bin/env bash

pylint -s n -ftext --exit-zero "$@" &>/dev/null || exit "$?"


(
  pylint -s n -ftext "$@" | grep -v '************* Module' | sed -E "s/^([^:]+:[0-9]+:[0-9]*:? )/\1[pylint] /";
  mypy --no-error-summary --follow-untyped-imports --check-untyped-defs --disallow-incomplete-defs "$@" | sed -E "s/^([^:]+:[0-9]+:[0-9]*:? )/\1[mypy] /;s/^([^:]+:[0-9]+:) \[/\10: [/";
  basedpyright "$@" | grep ':' | sed -E "s_^(\s*$PWD/|[0-9]+ errors,.*)__;s/^([^:]+:[0-9]+:?[0-9]* )/\1[basedpyright] /;s/^([^:]+:[0-9]+:[0-9]+) \[/\1: [/" | awk '/^[^[:space:]].*:[0-9]+:[0-9]+ - [^:]+:/{if(l!="")print l;l=$0;next}/^[[:space:]]+/{sub(/^[[:space:]\302\240]+/,"",$0);l=l": "$0;next}{if(l!="")print l;l=$0}END{if(l!="")print l}'
) | sort -t: -k1,1n -k2,2n -k3,3n
