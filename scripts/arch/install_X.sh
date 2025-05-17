#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

./scripts/config_sl.sh

printf "\nInstalling dependencies...\n"
pinn xorg-server xorg-xinit xorg-xset libx11 libxft libxinerama xorgproto xorg-xrandr autorandr xorg-xev xf86-input-evdev xclip slock maim feh picom

# Picom is an effects compositor for X11
cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf

# run build_sl script
./scripts/build_sl.sh
