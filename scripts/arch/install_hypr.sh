#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

pinn hyprland hyprpaper waybar wofi hyprlock wlr-randr wl-clipboard hypridle xorg-xhost

cp -fr ./configs/hypr /home/$SUDO_USER/.config && cp -fr ./configs/wofi /home/$SUDO_USER/.config && cp -r ./configs/waybar ~/.config

