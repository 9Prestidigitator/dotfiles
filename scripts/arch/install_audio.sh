#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
pacupdate

# The idea is to get an automatic install that follows:
# https://wiki.archlinux.org/title/Professional_audio
# But also may some automatic installation of my Reaper config and extensions
pinn reaper qjackctl
# Supposedly adding the user to the realtime group improves audio latency performance
sudo usermod -aG realtime $SUDO_USER
