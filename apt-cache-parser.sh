#!/usr/bin/env bash

apt-cache-parser() {
  local section pkg active line line_arr line_item line_piece line_data line_op deps
  section=$1
  pkg=$2
  case $section in
    "Provides"|"Reverse Provides")
      ;;
    "Dependencies")
      printf 'This script does not support the "Dependencies" section, due to it being impossible to tell the difference between "Depends", "Recommends", "Suggests", "Conflicts", "PreDepends", and "Breaks".\n' >&2
      printf 'Please select one of those instead.\n' >&2
      return 1
      ;;
    "Depends"|"Recommends"|"Suggests"|"Conflicts"|"PreDepends"|"Breaks")
      declare -A deps
      while IFS= read -r line; do
        # Taken from https://stackoverflow.com/a/3352015
        line="${line#"${line%%[![:space:]]*}"}"
        case $line in
        "Dependencies: ")
          active=1
          continue
          ;;
        "Package: $pkg"|"Versions: "|"Reverse Depends: "|\
        "Provides: "|"Reverse Provides: ")
          active=0
          continue
          ;;
        esac
        if [ $active -eq 1 ] && [ -n "$line" ]; then
          mapfile -t -d ' ' line_arr < <(printf '%s' "$line")
          line_item=""
          for line_piece in "${line_arr[@]:2}";do
            if [ "$line_item" == "" ];then
              line_item="$line_piece"
            else
              line_item="$line_item $line_piece"
            fi
            if [ "${line_item: -1}" == ")" ];then
              mapfile -t -d ' ' line_data < <(printf '%s' "$line_item")
              line_item="${line_data[2]:0:-1}"
              case "${line_data[1]:1}" in
                "1") line_op="<=";;
                "2") line_op=">=";;
                "3") line_op="<";;
                "4") line_op=">";;
                "5") line_op="=";;
                "6") line_op="!=";;
                *)   line_op="";;
              esac
              if [ "$line_item" != "" ] && [ "$line_op" != "" ];then
                deps["${line_data[0]}"]="${line_data[0]} $line_op $line_item"
              fi
              line_item=""
            fi
          done
        fi
      done < <(apt-cache showpkg -- "$pkg")
      while IFS= read -r line; do
        case "$line" in
          " "[\ \|]"$section:"*)
            line_item="${line# [ |]"$section": }"
            line_item="${line_item#<}"
            line_item="${line_item%>}"
            if [ -n "${deps[$line_item]}" ];then
              line_item="${deps[$line_item]}"
            fi
            printf '%s\n' "$line_item"
            ;;
        esac
      done < <(apt-cache depends -- "$pkg")
      return
      ;;
    "Reverse Depends")
      while IFS= read -r line; do
        case "$line" in
          " "[\ \|]*)
            line_item="${line# [ |]}"
            if [ "${line_item:0:2}" != "  " ];then
              printf '%s\n' "$line_item"
            fi
            ;;
        esac
      done < <(apt-cache rdepends -- "$pkg")
      return
      ;;
    *)
      printf 'Unknown apt-cache section "%s"\n' "$section" >&2
      printf 'Please select one of: "Breaks", "Conflicts", "Depends", "PreDepends", "Provides", "Recommends", "Reverse Depends", "Reverse Provides", "Suggests"\n' >&2
      return 1
      ;;
  esac

  active=0
  while IFS= read -r line; do
    # Taken from https://stackoverflow.com/a/3352015
    line="${line#"${line%%[![:space:]]*}"}"
    case $line in
    "$section: ")
      active=1
      continue
      ;;
    "Package: $pkg"|"Versions: "|"Reverse Depends: "|\
    "Dependencies: "|"Provides: "|"Reverse Provides: ")
      active=0
      continue
      ;;
    esac
    if [ $active -eq 1 ] && [ -n "$line" ]; then
      # do this here, since most of our cases split on spaces
      mapfile -t -d ' ' line_arr < <(printf '%s' "$line")
      case $section in
        "Reverse Provides")
          printf '%s\n' "${line_arr[0]}"
          ;;
        "Provides")
          line_item=""
          for line_piece in "${line_arr[@]:2}";do
            if [ "$line_item" == "" ];then
              line_item="$line_piece"
            else
              line_item="$line_item $line_piece"
            fi
            if [ "${line_item: -1}" == ")" ];then
              mapfile -t -d ' ' line_data < <(printf '%s' "$line_item")
              line_item="${line_data[2]:0:-1}"
              if [ "$line_item" == "" ];then
                printf '%s\n' "${line_data[0]}"
              else
                printf '%s %s %s\n' "${line_data[0]}" "${line_data[1]:1}" "${line_data[2]:0:-1}"
              fi
              line_item=""
            fi
          done
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    fi
  done < <(apt-cache showpkg -- "$pkg")
}

_acp-complete() {
  local CWORD="${COMP_WORDS[COMP_CWORD]}"
  if [ "$COMP_CWORD" -eq 1 ];then
    mapfile -t COMPREPLY < <(compgen -W 'Package Versions "Reverse Depends" Dependencies Provides "Reverse Provides"' -- "$CWORD")
  elif [ "$COMP_CWORD" -eq 2 ];then
    if [ "$CWORD" == "" ];then
      mapfile -t COMPREPLY < <(apt-cache pkgnames)
    else
      mapfile -t COMPREPLY < <(apt-cache pkgnames --all-names -- "$CWORD")
    fi
  fi
}

# Taken from https://github.com/bahamas10/bash-jsonvar/blob/main/jsonvar.bash
if ( return 0 &>/dev/null ); then
  complete -F _acp-complete apt-cache-parser
else
  apt-cache-parser "$@"
fi
