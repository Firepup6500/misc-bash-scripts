#!/bin/env bash

# https://technex.us/2022/05/how-to-make-a-launcher-for-spotify-in-linux-that-works-with-spotify-links/

# check if spotify is already running and if so just pass the uri in
if pgrep -f "Spotify/[0-9].[0-9].[0-9]" > /dev/null
then
  busline=busline=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri $1
  printf "Spotify is already running\n"
  printf "Sending ${busline} to dbus\n"
  if command -v qdbus &> /dev/null
  then
    qdbus $busline
    exit
  fi
  if command -v dbus-send &> /dev/null
  then
    dbus-send $busline
    exit
  fi
  printf "No bus dispatcher found.\n"
# otherwise launch spotify
else
  spotify $1 &>/dev/null &
fi
