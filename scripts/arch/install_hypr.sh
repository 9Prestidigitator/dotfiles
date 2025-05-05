#!/bin/bash
source ./scripts/bash_functions.sh
source ./scripts/arch/paccmds.sh
root_check
ensure_in_dir

pinn hyprland hyprpaper waybar wofi hyprlock wlr-randr wl-clipboard hypridle

cp -r ./configs/hypr ~/.config && cp -r ./configs/wofi ~/.config && cp -r ./configs/waybar ~/.config

