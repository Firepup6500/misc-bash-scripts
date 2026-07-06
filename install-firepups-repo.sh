#!/bin/bash
unset SUDO

error() {
  ERR=$?
  echo "Error: Failed to setup repo, please check above logs!"
  exit $?
}

trap 'error' ERR

set -x

if [ "$EUID" != "0" ]; then SUDO="sudo"; fi
if [ -f /usr/share/keyrings/firepups-repo.gpg ]; then
  echo "Deleting old signing key from /usr/share/keyrings/firepups-repo.gpg"
  $SUDO rm /usr/share/keyrings/firepups-repo.gpg
fi
echo "Storing signing key in /usr/share/keyrings/firepups-repo-keyring.gpg"
curl https://repo.firepup650.com/firepups-repo-keyring.gpg | $SUDO tee /usr/share/keyrings/firepups-repo-keyring.gpg >/dev/null
# If *I* don't do this check, apt will want to modernize the source anyways, so why not just handle it early
if (dpkg --compare-versions "$(apt --version | head -n1 | awk '{print $2}')" lt 2.7);then
  echo "Setting up repo in /etc/apt/sources.list.d/firepups-repo.list"
  echo "deb [signed-by=/usr/share/keyrings/firepups-repo-keyring.gpg] https://repo.firepup650.com/ main discord git misc security" | $SUDO tee /etc/apt/sources.list.d/firepups-repo.list >/dev/null
  echo "Running $SUDO apt update"
  $SUDO apt update
  echo "Installing keyring package ($SUDO apt install firepups-repo-keyring)"
  $SUDO apt install firepups-repo-keyring
else
  echo "Setting up repo in /etc/apt/sources.list.d/firepups-repo.sources"
  echo "Types: deb
URIs: https://repo.firepup650.com/
Suites: main
Components: discord git misc security
Signed-By: /usr/share/keyrings/firepups-repo-keyring.gpg" | $SUDO tee /etc/apt/sources.list.d/firepups-repo.sources >/dev/null
  echo "Installing keyring package ($SUDO apt install -U firepups-repo-keyring)"
  $SUDO apt install -U firepups-repo-keyring
fi
