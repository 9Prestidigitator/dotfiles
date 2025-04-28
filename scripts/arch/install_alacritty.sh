#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check

pacman -S --noconfirm alacritty
mkdir -p ~/.config/nvim && cp -fr ./configs/alacritty /home/$SUDO_USER/.config/
