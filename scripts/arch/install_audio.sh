#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
pacupdate

sudo -v

# Installing audio stuff
pinn pipewire pipewire-pulse pipewire-jack wireplumber realtime-privileges pavucontrol qjackctl yabridge yabridgectl

# There is a bug in the latest release of wine as of 06/03/2025 Where the UI on
# windows VSTs do not follow the position of the window. The last known version
# of wine to work with yabridge is 9.21: There's a better fork of wine that
# will likely lead to better performance So I gotta do some research.
# sudo pacman -U ./configs/wine/wine-staging-9.21-1-x86_64.pkg.tar.zst

# Need to add script below that makes pacman ignore updating wine.

# The idea is to get an automatic install that follows:
# https://wiki.archlinux.org/title/Professional_audio

# Supposedly adding the user to the realtime group improves audio latency performance
sudo usermod -aG realtime $(whoami)
sudo usermod -aG audio $(whoami)

# But also may some automatic installation of my Reaper config and extensions
pinn reaper reapack sws
[[ ! -d "$HOME/.config/REAPER" ]] && cp -fr ./configs/REAPER $HOME/.config

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
