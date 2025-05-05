#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

./scripts/config_sl.sh

echo -e "\nInstalling dependencies...\n"
pinn base-devel xorg-server xorg-xinit xorg-xset libx11 libxft libxinerama xorgproto xorg-xrandr autorandr xorg-xev xf86-input-evdev slock maim xclip feh picom
pinn
# Picom is an effects compositor for X11
cp -f ./configs/picom/picom.conf /etc/xdg/picom.conf

# run build_sl script
./scripts/build_sl.sh
