#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

# Adding config files
cp -f ./.bash_profile /home/$SUDO_USER/.bash_profile
cp -f ./.bashrc /home/$SUDO_USER/.bashrc
cp -f ./.xinitrc /home/$SUDO_USER/.xinitrc
cp -fr ./configs/fastfetch /home/$SUDO_USER/.config/
