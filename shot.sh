#!/usr/bin/env bash

BASEDIR="${HOME}/Pictures"
MODE="screen"
DELAY=0

usage() {
  printf "Usage: %s [OPTIONS]\n\n  screen, window, region     Select the type of shot to take (Default: screen)\n  --delay, -d seconds        The number of seconds to wait before taking a shot (Default: 0)\n  --basedir, -b directory    The base directory to put shots in (Default: \$HOME/Pictures)\n" "${0##*/}"
  exit "$1"
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    screen|window|region)
      MODE="$1"
      ;;
    -d|--delay)
      DELAY="$2"
      shift
      ;;
    -h|--help)
      usage 0
      ;;
    --basedir)
      BASEDIR="$2"
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage 1 >&2
      ;;
  esac
  shift
done

case "$MODE" in
  screen) OUTDIR="${BASEDIR}/Screenshots" ;;
  window) OUTDIR="${BASEDIR}/Windowshots" ;;
  region) OUTDIR="${BASEDIR}/Regionshots" ;;
  *)
    echo "Error: Impossible scenario" >&2
    exit 1
    ;;
esac

if [ ! -d "$OUTDIR" ] && ! mkdir -p "$OUTDIR";then
  echo "Error: Failed to create output directory ${OUTDIR}" >&2
  exit 1
fi

[ "$DELAY" -gt 0 ] && echo "Sleeping for $DELAY seconds..." && sleep "$DELAY"

TIMESTAMP="$(date +'%Y-%m-%d_%H:%M:%S.%N')"

case "$MODE" in
  screen)
	OUTFILE="$OUTDIR/screenshot_$TIMESTAMP.png"
    xwd -root|convert xwd:- "png:$OUTFILE"
    ;;
  window)
	OUTFILE="$OUTDIR/windowshot_$TIMESTAMP.png"
    xwd -frame|convert xwd:- "png:$OUTFILE"
    ;;
  region)
	OUTFILE="$OUTDIR/regionshot_$TIMESTAMP.png"
    import "png:$OUTFILE"
    ;;
  *)
    echo "Error: Impossible scenario" >&2
    exit 1
    ;;
esac

if [ -f "$OUTFILE" ]; then
  echo "Saved ${MODE}shot to $OUTFILE"
  notify-send "${MODE}shot saved" "Path: $OUTFILE" --icon "$OUTFILE"
  xclip -selection clipboard -t image/png -i "$OUTFILE"
else
  echo "Failed to save ${MODE}shot" >&2
  notify-send "Failed to save ${MODE}shot"
  exit 1
fi
