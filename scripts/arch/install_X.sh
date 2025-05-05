#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

./scripts/config_sl.sh

# run build_sl script
echo -e "\nInstalling dependencies...\n"
pinn base-devel xorg-server xorg-xinit xorg-xset libx11 libxft libxinerama 
# Extra X11 packages: slock is a basic lock screen, feh is background manager
pinn xorgproto xorg-xrandr autorandr xorg-xev xf86-input-evdev slock maim xclip feh picom
# Picom is an effects compositor for X11
cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf
# Installation of keyd
prompt_run "Install keyd" pinn keyd && mkdir -p /etc/keyd && cp -f /.configs/keyd/default.conf /etc/keyd/default.conf
./scripts/build_sl.sh
