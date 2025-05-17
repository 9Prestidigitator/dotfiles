#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

pinn hyprland hyprpaper waybar wofi hyprlock wlr-randr wl-clipboard hypridle xorg-xhost

cp -fr ./configs/hypr $HOME/.config && cp -fr ./configs/wofi $HOME/.config && cp -r ./configs/waybar ~/.config

