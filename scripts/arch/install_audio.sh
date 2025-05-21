#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh

sudo -v

pacupdate

# The idea is to get an automatic install that follows:
# https://wiki.archlinux.org/title/Professional_audio

# Supposedly adding the user to the realtime group improves audio latency performance
sudo usermod -aG realtime $(whoami)
sudo usermod -aG audio $(whoami)

# But also may some automatic installation of my Reaper config and extensions
pinn reaper qjackctl

# Overwitch; Overbridge substitute
cd $REPO_CLONES

git clone https://github.com/dagargo/overwitch.git
cd overwitch
autoreconf --install
./configure CLI_ONLY=yes
sudo make install
sudo ldconfig
cd udev
sudo make install

ensure_in_dir

